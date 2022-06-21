//
// libmavconn
// Copyright 2018 Vladimir Ermakov, All rights reserved.
//
// This file is part of the mavros package and subject to the license terms
// in the top-level LICENSE file of the mavros repository.
// https://github.com/mavlink/mavros/tree/master/LICENSE.md
//
/**
 * @brief MAVConn console-bridge compatibility header
 * @file console_bridge_compat.h
 * @author Vladimir Ermakov <vooon341@gmail.com>
 *
 * @addtogroup mavconn
 * @{
 */

#pragma once
#ifndef MAVCONN__CONSOLE_BRIDGE_COMPAT_HPP_
#define MAVCONN__CONSOLE_BRIDGE_COMPAT_HPP_

// #include <console_bridge/console.h>

// [[[cog:
// for idx, func in enumerate(('debug', 'inform', 'warn', 'error')):
//     fn = f'CONSOLE_BRIDGE_log{func.title()}'
//     fu = func.upper()
//
//     if func == 'inform':  # NOTE: special case
//         fu = 'INFO'
//
//     if idx != 0:
//         cog.outl()
//
//     cog.outl(f'#ifndef {fn}')
//     cog.outl(f'#define {fn}(fmt, ...) \\')
//     cog.outl(f'  console_bridge::log( \\')
//     cog.outl(f'    __FILE__, __LINE__, console_bridge::CONSOLE_BRIDGE_LOG_{fu}, fmt, \\')
//     cog.outl(f'    ## __VA_ARGS__)')
//     cog.outl(f'#endif  // {fn}')
// ]]]

#define CONSOLE_BRIDGE_BASE(LOG_LEVEL, fmt, ...) \
{                                        \
      std::string console_bridge_str(fmt);    \
      console_bridge_str = console_bridge_str.append(__FILE__).append(" ").append(std::to_string(__LINE__)).append(" ").append(LOG_LEVEL).append(": "); \
      printf(console_bridge_str.c_str(), \
        ## __VA_ARGS__); \
}

#ifndef CONSOLE_BRIDGE_logDebug
#define CONSOLE_BRIDGE_logDebug(fmt, ...) \
    CONSOLE_BRIDGE_BASE("DEBUG", fmt, __VA_ARGS__)
#endif  // CONSOLE_BRIDGE_logDebug

#ifndef CONSOLE_BRIDGE_logInform
#define CONSOLE_BRIDGE_logInform(fmt, ...) \
  CONSOLE_BRIDGE_BASE("INFORM", fmt, __VA_ARGS__)
#endif  // CONSOLE_BRIDGE_logInform

#ifndef CONSOLE_BRIDGE_logWarn
#define CONSOLE_BRIDGE_logWarn(fmt, ...) \
  CONSOLE_BRIDGE_BASE("WARN", fmt, __VA_ARGS__)
#endif  // CONSOLE_BRIDGE_logWarn

#ifndef CONSOLE_BRIDGE_logError
#define CONSOLE_BRIDGE_logError(fmt, ...) \
  CONSOLE_BRIDGE_BASE("ERROR", fmt, __VA_ARGS__)
#endif  // CONSOLE_BRIDGE_logError
// [[[end]]] (checksum: ac76c84da411728c99a9b3995d1ffe37)

#endif  // MAVCONN__CONSOLE_BRIDGE_COMPAT_HPP_
