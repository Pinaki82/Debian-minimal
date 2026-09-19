-- ================================================================
--  Conky Lua Script — Unified Clock + System Gauges
--  ┌─────────────────────────────────────┐
--  │   Two-handed analogue clock         │
--  │   • 60 tick marks                   │
--  │   • Day box  (upper dial, inside)   │
--  │   • Date box (lower dial, inside)   │
--  ├─────────────────────────────────────┤
--  │  [CPU %]   [RAM %]   [CPU Temp °C]  │
--  │  Arc gauges with value label        │
--  └─────────────────────────────────────┘
-- ================================================================

require 'cairo'

-- ── Temperature cache (re-read every 30 s, not every second) ────
local _temp_cache   = 0
local _temp_last_t  = 0
local _temp_interval = 30

local function get_cpu_temp()
    local now = os.time()
    if now - _temp_last_t >= _temp_interval then
        local f = io.popen(
            "sensors 2>/dev/null | grep 'Package id 0'" ..
            " | cut -d '+' -f2 | cut -c1-4")
        if f then
            local v = tonumber(f:read("*l"))
            f:close()
            if v then
                _temp_cache  = v
                _temp_last_t = now
            end
        end
    end
    return _temp_cache
end

-- ════════════════════════════════════════════════════════════════
--  TUNEABLE SETTINGS
-- ════════════════════════════════════════════════════════════════

-- ── Clock geometry ──────────────────────────────────────────────
local CX       = 110     -- clock centre X
local CY       = 108     -- clock centre Y
local RADIUS   = 88      -- outer edge of dial

-- ── Hands ───────────────────────────────────────────────────────
local HH_LEN   = 0.50    -- hour   hand length (fraction of RADIUS)
local HH_W     = 6       -- hour   hand width  (px)
local MH_LEN   = 0.82    -- minute hand length
local MH_W     = 3       -- minute hand width

-- ── Outer ring ──────────────────────────────────────────────────
local RING_W   = 2.5

-- ── Tick marks ──────────────────────────────────────────────────
local TICK_MAJ_L = 13    -- major tick length (every 5 min)
local TICK_MIN_L =  6    -- minor tick length (every 1 min)
local TICK_MAJ_W =  2.5
local TICK_MIN_W =  1.0

-- ── In-dial windows ─────────────────────────────────────────────
local WIN_W    = 86      -- box width
local WIN_H    = 20      -- box height
local WIN_R    =  4      -- corner radius
local WIN_FONT = "DejaVu Sans"
local DAY_OFF  = -RADIUS * 0.42   -- day  box: above centre
local DATE_OFF =  RADIUS * 0.42   -- date box: below centre

-- ── Arc Gauges (below the clock) ────────────────────────────────
--  Three gauges, evenly spaced across the 220 px window
local G_RADIUS  = 32     -- gauge arc outer radius
local G_WIDTH   = 7      -- arc stroke width
local G_Y       = CY + RADIUS + G_RADIUS + 18  -- centre Y of all gauges
local G_FONT    = "DejaVu Sans"

local G = {
    --  label        cx    max   unit    R     G     B
    { "CPU",        37,   100,  "%",   0.20, 0.80, 1.00 },
    { "RAM",       110,   100,  "%",   0.20, 1.00, 0.55 },
    { "TEMP",      183,   105,  "°C",  1.00, 0.55, 0.20 },
}

-- Arc sweep: starts at ~225° and sweeps 270° clockwise (speedometer style)
-- In Cairo, angles are from the +X axis (3 o'clock), clockwise.
-- 225° from 12 o'clock  =  225 - 90  = 135° from +X  = 3π/4
-- 270° sweep
local ARC_START  = (135)  * math.pi / 180
local ARC_SWEEP  = (270)  * math.pi / 180

-- ════════════════════════════════════════════════════════════════
--  HELPER FUNCTIONS
-- ════════════════════════════════════════════════════════════════

-- Rounded rectangle path
local function rrect(cr, x, y, w, h, r)
    cairo_move_to(cr, x + r, y)
    cairo_line_to(cr, x + w - r, y)
    cairo_arc(cr, x + w - r, y + r,     r, -math.pi/2, 0)
    cairo_line_to(cr, x + w, y + h - r)
    cairo_arc(cr, x + w - r, y + h - r, r,  0,          math.pi/2)
    cairo_line_to(cr, x + r, y + h)
    cairo_arc(cr, x + r,     y + h - r, r,  math.pi/2,  math.pi)
    cairo_line_to(cr, x, y + r)
    cairo_arc(cr, x + r,     y + r,     r,  math.pi,    3*math.pi/2)
    cairo_close_path(cr)
end

-- Horizontally & vertically centred text inside a box
local function centred_text(cr, text, bx, by, bw, bh, fsize, r, g, b, a, bold)
    cairo_select_font_face(cr, WIN_FONT,
        CAIRO_FONT_SLANT_NORMAL,
        bold and CAIRO_FONT_WEIGHT_BOLD or CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, fsize)
    cairo_set_source_rgba(cr, r, g, b, a)
    local te = cairo_text_extents_t:create()
    cairo_text_extents(cr, text, te)
    cairo_move_to(cr,
        bx + (bw - te.width)  / 2 - te.x_bearing,
        by + (bh + te.height) / 2 - te.y_bearing - te.height)
    cairo_show_text(cr, text)
end

-- Clock hand
local function draw_hand(cr, angle, length, width, r, g, b, a)
    cairo_move_to(cr, CX, CY)
    cairo_line_to(cr,
        CX + length * math.sin(angle),
        CY - length * math.cos(angle))
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr, width)
    cairo_set_source_rgba(cr, r, g, b, a)
    cairo_stroke(cr)
end

-- ── Arc gauge ───────────────────────────────────────────────────
local function draw_gauge(cr, gx, gy, value, max_val,
                           label, unit, cr2, cg2, cb2)
    local pct      = math.max(0, math.min(value / max_val, 1))
    local fill_end = ARC_START + pct * ARC_SWEEP

    -- Background arc (dim)
    cairo_arc(cr, gx, gy, G_RADIUS - G_WIDTH/2, ARC_START, ARC_START + ARC_SWEEP)
    cairo_set_line_width(cr, G_WIDTH)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.10)
    cairo_stroke(cr)

    -- Coloured value arc
    if pct > 0 then
        cairo_arc(cr, gx, gy, G_RADIUS - G_WIDTH/2, ARC_START, fill_end)
        cairo_set_line_width(cr, G_WIDTH)
        cairo_set_source_rgba(cr, cr2, cg2, cb2, 0.90)
        cairo_stroke(cr)
    end

    -- Outer ring border
    cairo_arc(cr, gx, gy, G_RADIUS, 0, 2 * math.pi)
    cairo_set_line_width(cr, 1.0)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.25)
    cairo_stroke(cr)

    -- Value text (centred in gauge circle)
    local val_str
    if unit == "°C" then
        val_str = string.format("%d°", math.floor(value))
    else
        val_str = string.format("%d%%", math.floor(value))
    end
    centred_text(cr, val_str,
        gx - G_RADIUS, gy - G_RADIUS/2,
        G_RADIUS * 2,  G_RADIUS,
        10, cr2, cg2, cb2, 1.0, true)

    -- Label text (below the gauge circle)
    centred_text(cr, label,
        gx - G_RADIUS, gy + G_RADIUS + 2,
        G_RADIUS * 2,  12,
        9, 1.0, 1.0, 1.0, 0.75, false)
end

-- ════════════════════════════════════════════════════════════════
--  MAIN ENTRY POINT  (called by Conky every update_interval)
-- ════════════════════════════════════════════════════════════════

function conky_draw_all()
    if conky_window == nil then return end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)
    local cr = cairo_create(cs)

    -- ── Live values ────────────────────────────────────────────
    local hours   = tonumber(os.date("%I"))
    local minutes = tonumber(os.date("%M"))
    local cpu_pct = tonumber(conky_parse("${cpu cpu0}"))   or 0
    local ram_pct = tonumber(conky_parse("${memperc}"))    or 0
    local cpu_tmp = get_cpu_temp()

    -- ════════════════════════════════════════════════════════
    --  SECTION 1 — ANALOG CLOCK
    -- ════════════════════════════════════════════════════════

    -- 1a. Outer ring
    cairo_arc(cr, CX, CY, RADIUS, 0, 2 * math.pi)
    cairo_set_line_width(cr, RING_W)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.85)
    cairo_stroke(cr)

    -- 1b. 60 tick marks
    for i = 0, 59 do
        local ang    = (i / 60) * 2 * math.pi
        local major  = (i % 5 == 0)
        local tl     = major and TICK_MAJ_L or TICK_MIN_L
        local tw     = major and TICK_MAJ_W or TICK_MIN_W
        cairo_move_to(cr,
            CX +  RADIUS       * math.sin(ang),
            CY -  RADIUS       * math.cos(ang))
        cairo_line_to(cr,
            CX + (RADIUS - tl) * math.sin(ang),
            CY - (RADIUS - tl) * math.cos(ang))
        cairo_set_line_width(cr, tw)
        cairo_set_line_cap(cr, CAIRO_LINE_CAP_BUTT)
        cairo_set_source_rgba(cr, 1, 1, 1, 0.80)
        cairo_stroke(cr)
    end

    -- 1c. DAY box (upper inside dial)
    -- local day_str  = os.date("%A")
    local day_str  = os.date("%a")
    local dbx = CX - WIN_W/2
    local dby = CY + DAY_OFF - WIN_H/2

    rrect(cr, dbx, dby, WIN_W, WIN_H, WIN_R)
    cairo_set_source_rgba(cr, 0.05, 0.05, 0.12, 0.65)
    cairo_fill(cr)
    rrect(cr, dbx, dby, WIN_W, WIN_H, WIN_R)
    cairo_set_line_width(cr, 1.0)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.50)
    cairo_stroke(cr)
    centred_text(cr, day_str, dbx, dby, WIN_W, WIN_H,
                 11, 1.0, 0.90, 0.45, 1.0, true)

    -- 1d. DATE box (lower inside dial)
    -- local date_str = os.date("%d %b %Y")
    local date_str = os.date("%d %b %y")
    local dtx = CX - WIN_W/2
    local dty = CY + DATE_OFF - WIN_H/2

    rrect(cr, dtx, dty, WIN_W, WIN_H, WIN_R)
    cairo_set_source_rgba(cr, 0.05, 0.05, 0.12, 0.65)
    cairo_fill(cr)
    rrect(cr, dtx, dty, WIN_W, WIN_H, WIN_R)
    cairo_set_line_width(cr, 1.0)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.50)
    cairo_stroke(cr)
    centred_text(cr, date_str, dtx, dty, WIN_W, WIN_H,
                 11, 1.0, 1.0, 1.0, 1.0, true)

    -- 1e. Hour hand (with fractional sweep between hour marks)
    local h_ang = ((hours % 12) / 12 + minutes / 720) * 2 * math.pi
    draw_hand(cr, h_ang, RADIUS * HH_LEN, HH_W, 1, 1, 1, 1.0)

    -- 1f. Minute hand
    local m_ang = (minutes / 60) * 2 * math.pi
    draw_hand(cr, m_ang, RADIUS * MH_LEN, MH_W, 1, 1, 1, 0.95)

    -- 1g. Centre dot (on top of both hands)
    cairo_arc(cr, CX, CY, 5, 0, 2 * math.pi)
    cairo_set_source_rgba(cr, 1, 1, 1, 1)
    cairo_fill(cr)

    -- ════════════════════════════════════════════════════════
    --  SECTION 2 — SYSTEM GAUGES
    -- ════════════════════════════════════════════════════════

    -- Thin separator line between clock and gauges
    local sep_y = CY + RADIUS + 8
    cairo_move_to(cr, 10, sep_y)
    cairo_line_to(cr, 210, sep_y)
    cairo_set_line_width(cr, 0.8)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.25)
    cairo_stroke(cr)

    -- Draw each gauge using the G table
    -- local values = { cpu_pct, ram_pct, cpu_tmp }
    -- for i, g in ipairs(G) do
    --     draw_gauge(cr,
    --         g[2], G_Y,          -- cx, cy
    --         values[i], g[3],    -- value, max
    --         g[1], g[4],         -- label, unit
    --         g[5], g[6], g[7])   -- R, G, B
    -- end


    -- ── Dynamic gauge colours ──────────────────────────────────
    --
    -- CPU: turns red above 75% (safe working limit)
    --      Normal = blue (0.20, 0.80, 1.00)
    --      Alert  = red  (1.00, 0.20, 0.20)
    local cpu_r = cpu_pct > 75 and 1.00 or 0.20
    local cpu_g = cpu_pct > 75 and 0.20 or 0.80
    local cpu_b = cpu_pct > 75 and 0.20 or 1.00

    -- TEMP: turns red above 60°C
    --       Normal = orange (0.20, 0.55, 0.20) → wait, kept as original below
    --       Alert  = red    (1.00, 0.20, 0.20)
    local tr = cpu_tmp > 60 and 1.00 or 1.00
    local tg = cpu_tmp > 60 and 0.20 or 0.55
    local tb = cpu_tmp > 60 and 0.20 or 0.20

    -- RAM: turns red above 85%
    --      Normal = green (0.20, 1.00, 0.55)
    --      Alert  = red   (1.00, 0.20, 0.20)
    local ram_r = ram_pct > 85 and 1.00 or 0.20
    local ram_g = ram_pct > 85 and 0.20 or 1.00
    local ram_b = ram_pct > 85 and 0.20 or 0.55

    -- RAM keeps its fixed green colour (no threshold set)
    -- Draw all three gauges individually with dynamic colours applied
    draw_gauge(cr, G[1][2], G_Y, cpu_pct, G[1][3], G[1][1], G[1][4],
               cpu_r, cpu_g, cpu_b)   -- CPU  (dynamic)

    draw_gauge(cr, G[2][2], G_Y, ram_pct, G[2][3], G[2][1], G[2][4],
               G[2][5], G[2][6], G[2][7])  -- RAM  (fixed green)

    draw_gauge(cr, G[3][2], G_Y, cpu_tmp, G[3][3], G[3][1], G[3][4],
               tr, tg, tb)            -- TEMP (dynamic)

    draw_gauge(cr, G[2][2], G_Y, ram_pct, G[2][3], G[2][1], G[2][4],
               ram_r, ram_g, ram_b)   -- RAM  (dynamic)

    -- Cleanup
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
