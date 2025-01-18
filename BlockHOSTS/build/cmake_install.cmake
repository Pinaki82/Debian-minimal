# Install script for directory: /mnt/hdd/HOME/BlockHOSTS

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/appu/.local/bin/hosts_manager" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/appu/.local/bin/hosts_manager")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/appu/.local/bin/hosts_manager"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/appu/.local/bin/hosts_manager")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/appu/.local/bin" TYPE EXECUTABLE PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE FILES "/mnt/hdd/HOME/BlockHOSTS/build/hosts_manager")
  if(EXISTS "$ENV{DESTDIR}/home/appu/.local/bin/hosts_manager" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/appu/.local/bin/hosts_manager")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/appu/.local/bin/hosts_manager")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
    file(MAKE_DIRECTORY "/home/appu/.config/hosts_manager")
    if(EXISTS "/mnt/hdd/HOME/BlockHOSTS/hosts.backup.txt")
        file(COPY "/mnt/hdd/HOME/BlockHOSTS/hosts.backup.txt" DESTINATION "/home/appu/.config/hosts_manager")
        file(CHMOD "/home/appu/.config/hosts_manager/hosts.backup.txt" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
    if(EXISTS "/mnt/hdd/HOME/BlockHOSTS/hosts_config.txt")
        file(COPY "/mnt/hdd/HOME/BlockHOSTS/hosts_config.txt" DESTINATION "/home/appu/.config/hosts_manager")
        file(CHMOD "/home/appu/.config/hosts_manager/hosts_config.txt" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
    if(EXISTS "/mnt/hdd/HOME/BlockHOSTS/hosts-Win10-default.txt")
        file(COPY "/mnt/hdd/HOME/BlockHOSTS/hosts-Win10-default.txt" DESTINATION "/home/appu/.config/hosts_manager")
        file(CHMOD "/home/appu/.config/hosts_manager/hosts-Win10-default.txt" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()
    if(EXISTS "/mnt/hdd/HOME/BlockHOSTS/Personal-hosts-blocklist.txt")
        file(COPY "/mnt/hdd/HOME/BlockHOSTS/Personal-hosts-blocklist.txt" DESTINATION "/home/appu/.config/hosts_manager")
        file(CHMOD "/home/appu/.config/hosts_manager/Personal-hosts-blocklist.txt" PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    endif()

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/mnt/hdd/HOME/BlockHOSTS/build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/mnt/hdd/HOME/BlockHOSTS/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
