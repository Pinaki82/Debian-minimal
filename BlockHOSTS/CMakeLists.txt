cmake_minimum_required(VERSION 3.10)
project(hosts_manager C)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Define build types
set(CMAKE_CONFIGURATION_TYPES Debug Release)

# Debug build settings
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")

# Release build settings
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -s")

# Add executable
add_executable(hosts_manager hosts_manager.c)

# Installation paths
include(GNUInstallDirs)
set(INSTALL_BIN_DIR "$ENV{HOME}/.local/bin" CACHE PATH "Installation directory for executables")
set(CONFIG_DIR "$ENV{HOME}/.config/hosts_manager" CACHE PATH "Configuration directory")

# Install the executable
install(TARGETS hosts_manager
        RUNTIME DESTINATION ${INSTALL_BIN_DIR}
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# Create configuration directory and copy default config files if they exist
install(CODE "
    file(MAKE_DIRECTORY \"${CONFIG_DIR}\")
    if(EXISTS \"${CMAKE_CURRENT_SOURCE_DIR}/hosts.backup.txt\")
        file(COPY \"${CMAKE_CURRENT_SOURCE_DIR}/hosts.backup.txt\" DESTINATION \"${CONFIG_DIR}\")
        file(CHMOD \"${CONFIG_DIR}/hosts.backup.txt\" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
    if(EXISTS \"${CMAKE_CURRENT_SOURCE_DIR}/hosts_config.txt\")
        file(COPY \"${CMAKE_CURRENT_SOURCE_DIR}/hosts_config.txt\" DESTINATION \"${CONFIG_DIR}\")
        file(CHMOD \"${CONFIG_DIR}/hosts_config.txt\" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
    if(EXISTS \"${CMAKE_CURRENT_SOURCE_DIR}/hosts-Win10-default.txt\")
        file(COPY \"${CMAKE_CURRENT_SOURCE_DIR}/hosts-Win10-default.txt\" DESTINATION \"${CONFIG_DIR}\")
        file(CHMOD \"${CONFIG_DIR}/hosts-Win10-default.txt\" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
    if(EXISTS \"${CMAKE_CURRENT_SOURCE_DIR}/Personal-hosts-blocklist.txt\")
        file(COPY \"${CMAKE_CURRENT_SOURCE_DIR}/Personal-hosts-blocklist.txt\" DESTINATION \"${CONFIG_DIR}\")
        file(CHMOD \"${CONFIG_DIR}/Personal-hosts-blocklist.txt\" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
")
