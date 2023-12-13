/// ##########################################################################
/// @copyright Copyright (c) 2023, AI & ARTS Alchemy. All rights reserved.
/// ##########################################################################
#include "Project/ProjectLib.hpp"

namespace project::lib {
  int better_main(std::span<const std::string_view> args) noexcept {
    for (const auto& arg : args) {
      std::cout << arg << '\n';
    }
    std::cout << std::endl;

    return 0;
  }

} // namespace project::lib
