/// ##########################################################################
/// @copyright Copyright (c) 2023, AI & ARTS Alchemy. All rights reserved.
/// ##########################################################################
#ifndef PROJECT_LIB_H
#define PROJECT_LIB_H

#pragma once
#include <span>
#include <string_view>

namespace project::lib {
  /// @brief
  /// @param args
  /// @return 0 if function behaves correctly
  [[nodiscard]] int better_main(std::span<const std::string_view> args) noexcept;

} // namespace project::lib

#endif // PROJECT_LIB_H
