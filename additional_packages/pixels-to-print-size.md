# Pixels to Print Size

Ref:

1. https://photo.stackexchange.com/questions/456/is-there-a-general-formula-for-image-size-vs-print-size

2. [Omni Calculator logo](https://www.omnicalculator.com/other/pixels-to-print-size)

A general formula:

$$
\frac{Width[pixels]}{PrintRes[pixPerInch]} = printWidth[Inch]

$$

$$
\frac{Height[pixels]}{PrintRes[pixPerInch]} = printHeight[Inch]
$$

1 Inch = 25.4 Millimeter

The size of a Stamp Size photo = 25 mm (width) x 35 mm (height)

That means, the dimension of a Stamp Size photo in pixels at 300 DPI should be:

Width = $\frac{25}{25.4} \times 300 = 295.275590511 \simeq 295.3$ pix [$\because$ 1 Inch = 25.4 Millimeter]

Height = $\frac{35}{25.4} \times 300 = 413.385826772 \simeq 413.4$ pix [$\because$ 1 Inch = 25.4 Millimeter]

The same formula in reverse:

$$
printWidth[Inches] \times printResolution[pixPerInch] = width[pixels]
$$

$$
printHeight[Inches] \times printResolution[pixPerInch] = height[pixels]
$$

Thus,

Width = $\frac{25}{25.4} \times 300 = 295.275590511 \simeq 295.3$ pix [$\because$ 1 Inch = 25.4 Millimeter]

Height = $\frac{35}{25.4} \times 300 = 413.385826772 \simeq 413.4$ pix [$\because$ 1 Inch = 25.4 Millimeter]

---

The size of an Employee ID Card Photo = 35 mm (width) x 45 mm (height)

Which means,

Width = $\frac{35}{25.4} \times 300 = 413.385826772 \simeq 413.4$ pix [$\because$ 1 Inch = 25.4 Millimeter]

Height = $\frac{45}{25.4} \times 300 = 531.496062992 \simeq 531.5$ pix [$\because$ 1 Inch = 25.4 Millimeter]

---

ImageMagick  Montage has a working resolution of 72 DPI.

[How to Understand Pixels, Resolution, and Resize Your Images in Photoshop Correctly](https://digital-photography-school.com/understand-pixels-resolution-resize-photoshop/)

> If an image is 4500 x 3000 pixels it means that it will print at 15 x 10
>  inches if you set the resolution to 300 dpi, but it will be 62.5 x 41.6
>  inches at 72 dpi. While the size of your print does change, you are not
>  resizing your photo (image file), you are just reorganizing the 
> existing pixels.

[converting the coordinates of a 300 dpi image to coordinates of a 72 dpi image - Stack Overflow](https://stackoverflow.com/questions/15897334/converting-the-coordinates-of-a-300-dpi-image-to-coordinates-of-a-72-dpi-image)

> To convert from 300DPI to 72DPI, you need to multiply by 72/300, not 
> the other way round. Do it in floating point or the multiplication first
>  and division then, as in (x * 72) / 300. PDF units are always 1/72 of 
> an inch.
> 
> Scaling down the original image is not a good idea, since the loss of information will reduce the output text quality.

Our Stamp Size photo will essentially be $25 \times \frac{300}{72} = 25 \times 4.166666667 \simeq 25 \times 4.17 = 104.25$ pix (Width)

by

$35 \times \frac{300}{72} = 35 \times 4.166666667 \simeq 35 \times 4.17 = 145.95$ pix (Width)

---

https://superuser.com/questions/1635868/how-can-i-with-linux-easily-create-a-collage-of-passport-photos

https://ostechnix.com/how-to-create-a-montage-from-images-in-linux/

https://opensource.com/article/21/9/photo-montage-imagemagick

https://imagemagick.org/script/command-line-options.php

https://github.com/dpar39/ppp

---

```bash
yes | sudo apt install imagemagick graphicsmagick-imagemagick-compat
```

`montage IMG_20211008_132718.jpg IMG_20211008_132718.jpg IMG_20211008_132718.jpg IMG_20211008_132718.jpg IMG_20211008_132718.jpg IMG_20211008_132718.jpg -geometry +2+3 out.jpg`

```bash
montage \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
IMG_20211008_132718.jpg \
-tile 3x4 \
-resize 1200x1800 \
-geometry +2+3 out.jpg
```

### Image size and space between the images

`-tile` option helps you to instruct how the images should be arranged and placed on the montage.

`-tile 3x4` means 3x4 tiles in aggregate.

`-tile x1` means one row only.

`-resize 1200x1800` means produce a 1200x1800 pixel output montage.

The option `-geometry` helps you to set the thumbnail size and the space between each image. The default `-geometry` setting is `'120x120>+4+3'`. This means it will produce 120×120 pixel thumbnails with 4 pixels on the left and right of each image and 3 pixels below. Here `>` is the resize option. The option is useful for shrinking the size of the input images that are of higher dimensions.

`'width x height > +4 px spacing on the left/right +3 px spacing below'`

---

Now we will calculate the values to be submitted to Montage to generate a 4"x6" photo paper filled with Stamp Size Photo IDs.
