INCLUDE(${CMAKE_CURRENT_LIST_DIR}/Modules/LocateSTMUtil.cmake)

MACRO(STM32_LOCATE_STDPERIPH_LIB)
    IF(${STM32_FAMILY} STREQUAL "F0")
        IF(NOT STM32F0_StdPeriphLib_DIR)
            SET(STM32F0_StdPeriphLib_DIR "/opt/STM32F0xx_StdPeriph_Lib_V1.3.1")
            MESSAGE(STATUS "No STM32F0_StdPeriphLib_DIR specified, using default: " ${STM32F0_StdPeriphLib_DIR})
        ENDIF()
    ELSEIF(${STM32_FAMILY} STREQUAL "F1")
        IF(NOT STM32F1_StdPeriphLib_DIR)
            SET(STM32F1_StdPeriphLib_DIR "/opt/STM32F10x_StdPeriph_Lib_V3.5.0")
            MESSAGE(STATUS "No STM32F1_StdPeriphLib_DIR specified, using default: " ${STM32F1_StdPeriphLib_DIR})
        ENDIF()
    ELSEIF(${STM32_FAMILY} STREQUAL "F2")
        IF(NOT STM32F2_StdPeriphLib_DIR)
            SET(STM32F2_StdPeriphLib_DIR "/opt/STM32F2xx_StdPeriph_Lib_V1.1.0")
            MESSAGE(STATUS "No STM32F2_StdPeriphLib_DIR specified, using default: " ${STM32F2_StdPeriphLib_DIR})
        ENDIF()
    ELSEIF(${STM32_FAMILY} STREQUAL "F4")
        IF(NOT STM32F4_StdPeriphLib_DIR)
            SET(STM32F4_StdPeriphLib_DIR "/opt/STM32F4xx_DSP_StdPeriph_Lib_V1.3.0")
            MESSAGE(STATUS "No STM32F4_StdPeriphLib_DIR specified, using default: " ${STM32F4_StdPeriphLib_DIR})
        ENDIF()
    ENDIF()

    SET(STM32_StdPeriphLib_DIR ${STM32${STM32_FAMILY}_StdPeriphLib_DIR})
   
    STM32_LOCATE_CMSIS_PATH()
    STM32_LOCATE_CMSIS_INCLUDE_DIRECTORIES()
    STM32_LOCATE_CMSIS_HEADERS()
    
    STM32_LOCATE_STDPERIPH_PATH()
    STM32_LOCATE_STDPERIPH_INCLUDE_DIRECTORIES()
    STM32_LOCATE_STDPERIPH_HEADERS()
ENDMACRO()

MACRO(SET_IF_EXISTS var path)
    IF(NOT ${var})
       IF(EXISTS ${path})
          SET(${var} ${path})
       ELSE()
          SET(${var} ${var}-NOTFOUND)
       ENDIF()
    ENDIF()
ENDMACRO()

MACRO(STM32_LOCATE_CMSIS_PATH)
    FOREACH(TMP_FAMILY ${STM32_SUPPORTED_FAMILIES})
       SET_IF_EXISTS(STM32_CMSIS_PATH_${TMP_FAMILY} ${STM32${TMP_FAMILY}_StdPeriphLib_DIR}/Libraries/CMSIS)
       SET_IF_EXISTS(STM32_CMSIS_PATH_${TMP_FAMILY} ${STM32${TMP_FAMILY}_StdPeriphLib_DIR}/Drivers/CMSIS)
    ENDFOREACH()
    SET(STM32_CMSIS_PATH STM32_CMSIS_PATH_${STM32_FAMILY})
ENDMACRO()

MACRO(STM32_LOCATE_CMSIS_INCLUDE_DIRECTORIES)
    SET(STM32_CMSIS_INCLUDE_DIRECTORIES_F0
        ${STM32_CMSIS_PATH_F0}/Device/ST/STM32F0xx/Include/
        ${STM32_CMSIS_PATH_F0}/Include/
    )
    SET(STM32_CMSIS_INCLUDE_DIRECTORIES_F1
        ${STM32_CMSIS_PATH_F1}/Device/ST/STM32F10x/Include/
        ${STM32_CMSIS_PATH_F1}/Include/
    )
    SET(STM32_CMSIS_INCLUDE_DIRECTORIES_F2
        ${STM32_CMSIS_PATH_F2}/Device/ST/STM32F2xx/Include/
        ${STM32_CMSIS_PATH_F2}/Include/
    )
    SET(STM32_CMSIS_INCLUDE_DIRECTORIES_F4
        ${STM32_CMSIS_PATH_F4}/Device/ST/STM32F4xx/Include/
        ${STM32_CMSIS_PATH_F4}/Include/
    )
    SET(STM32_CMSIS_INCLUDE_DIRECTORIES ${STM32_CMSIS_INCLUDE_DIRECTORIES_${STM32_FAMILY}})
ENDMACRO()

MACRO(STM32_LOCATE_CMSIS_HEADERS)
    STM32_LOCATE_CMSIS_REL_HEADERS()

    FOREACH(TMP_FAMILY ${STM32_SUPPORTED_FAMILIES})
       STM32_PREPEND_FILE_NAMES(STM32_CMSIS_HEADERS_${TMP_FAMILY} "${STM32_CMSIS_PATH_${TMP_FAMILY}}/" ${STM32_CMSIS_REL_HEADERS_${TMP_FAMILY}})
    ENDFOREACH()
    SET(STM32_CMSIS_HEADERS ${STM32_CMSIS_HEADERS_${STM32_FAMILY}})
ENDMACRO()

MACRO(STM32_LOCATE_STDPERIPH_PATH)
    SET(STM32_STDPERIPH_PATH_F0 ${STM32F0_StdPeriphLib_DIR}/Libraries/STM32F0xx_StdPeriph_Driver)
    SET(STM32_STDPERIPH_PATH_F1 ${STM32F1_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver)
    SET_IF_EXISTS(STM32_STDPERIPH_PATH_F2 ${STM32F2_StdPeriphLib_DIR}/Libraries/STM32F2xx_StdPeriph_Driver)
    SET_IF_EXISTS(STM32_STDPERIPH_PATH_F2 ${STM32F2_StdPeriphLib_DIR}/Drivers/STM32F2xx_HAL_Driver)
    SET(STM32_STDPERIPH_PATH_F4 ${STM32F4_StdPeriphLib_DIR}/Libraries/STM32F4xx_StdPeriph_Driver)
    SET(STM32_STDPERIPH_PATH ${STM32_STDPERIPH_PATH_${STM32_FAMILY}})
ENDMACRO()                  

MACRO(STM32_LOCATE_STDPERIPH_INCLUDE_DIRECTORIES)
    FOREACH(TMP_FAMILY ${STM32_SUPPORTED_FAMILIES})
       SET(STM32_STDPERIPH_INCLUDE_DIRECTORIES_${TMP_FAMILY} ${STM32_STDPERIPH_PATH_${STM32_FAMILY}}/inc/)
    ENDFOREACH()
    SET(STM32_STDPERIPH_INCLUDE_DIRECTORIES ${STM32_STDPERIPH_INCLUDE_DIRECTORIES_${STM32_FAMILY}})
ENDMACRO()

MACRO(STM32_LOCATE_STDPERIPH_HEADERS)
    STM32_LOCATE_STDPERIPH_REL_HEADERS()
    FOREACH(TMP_FAMILY ${STM32_SUPPORTED_FAMILIES})
       STM32_PREPEND_FILE_NAMES(STM32_STDPERIPH_HEADERS_${TMP_FAMILY} ${STM32_STDPERIPH_PATH_${STM32_FAMILY}}/inc/ ${STM32_STDPERIPH_REL_HEADERS_${TMP_FAMILY}})
    ENDFOREACH()
    SET(STM32_STDPERIPH_HEADERS ${STM32_STDPERIPH_HEADERS_${STM32_FAMILY}})
ENDMACRO()
