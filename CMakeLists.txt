cmake_minimum_required(VERSION 3.31.5)

project(${SKBUILD_PROJECT_NAME}
    VERSION ${SKBUILD_PROJECT_VERSION}
    LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Dependencies
set(PYBIND11_FINDPYTHON ON)
find_package(pybind11 CONFIG REQUIRED)
find_package(Boost REQUIRED COMPONENTS program_options system thread)
find_package(FFTW3 REQUIRED)
find_package(UHD REQUIRED)
find_package(Threads REQUIRED)

# Define library sources
set(LIB_SOURCES
    src/sdr_record.cpp
    src/usrp.cpp
    src/iq_data.cpp
    src/dspv3.cpp
    src/sdr_test.cpp
    src/sdr_generator.cpp
    src/ping_sink.cpp
    src/airspy.cpp
    src/hackrf.cpp
    src/utils.cpp
)

# Python module
pybind11_add_module(_radio_telemetry_tracker_dsp4_build ${LIB_SOURCES})
target_compile_definitions(_radio_telemetry_tracker_dsp4_build PRIVATE
    VERSION_INFO=${PROJECT_VERSION}
    USE_PYBIND11=1
)

# Test executable
add_executable(pingFinderTest 
    ${LIB_SOURCES}
    src/test_PingFinder.cpp
)
target_compile_definitions(pingFinderTest PRIVATE
    VERSION_INFO=${EXAMPLE_VERSION_INFO}
    USE_PYBIND11=0
)

# Common link libraries for both targets
set(COMMON_LIBS
    UHD::UHD
    FFTW3::fftw3
    FFTW3::fftw3_threads
    Boost::system
    Boost::thread
    Threads::Threads
    airspy
    hackrf
    m
)

# Link libraries
target_link_libraries(_radio_telemetry_tracker_dsp4_build PRIVATE ${COMMON_LIBS})
target_link_libraries(pingFinderTest PRIVATE ${COMMON_LIBS})

# Installation
install(TARGETS _radio_telemetry_tracker_dsp4_build DESTINATION .)


