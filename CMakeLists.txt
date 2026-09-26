cmake_minimum_required(VERSION 3.16)

set(PROJECT_NAME lingmo-terminal)
project(${PROJECT_NAME})

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT Core Gui Quick QuickControls2 Widgets DBus LinguistTools)
find_package(Qt6 CONFIG REQUIRED ${QT})

# QML modules are installed below the Qt 6 QML import directory (e.g. /usr/lib/qt6/qml)
set(INSTALL_QMLDIR "${CMAKE_INSTALL_PREFIX}/${QT6_INSTALL_QML}")
message(STATUS "qml directory: ${INSTALL_QMLDIR}")

set(SRCS
    src/main.cpp
    src/processhelper.h
    src/processhelper.cpp
    src/utils.cpp
    src/fonts.cpp
)

set(RESOURCES
    src/resources.qrc
)

add_subdirectory(qmltermwidget)
add_executable(${PROJECT_NAME} ${SRCS} ${RESOURCES})
target_link_libraries(${PROJECT_NAME} PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Widgets
        Qt6::DBus
)

file(GLOB TS_FILES translations/*.ts)
foreach(filepath ${TS_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND ts_files_replaced ${filename})
endforeach()
qt_add_translation(QM_FILES ${ts_files_replaced})
add_custom_target(translations ALL DEPENDS ${QM_FILES} SOURCES ${TS_FILES})

install(FILES ${QM_FILES} DESTINATION /usr/share/lingmo-terminal/translations)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION /usr/bin)

install(FILES
    lingmo-terminal.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
