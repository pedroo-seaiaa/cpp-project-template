/// ##########################################################################
/// @copyright Copyright (c) 2023, AI & ARTS Alchemy. All rights reserved.
/// ##########################################################################
#ifndef AIAA_PROJECT_LIB_HPP
#define AIAA_PROJECT_LIB_HPP

#pragma once

namespace aiaa::project {

  class Application;

  /***************************************************************************
   * @brief A better main that allows for a more flexible interface with a span of string_views.
   *
   * @param args
   * @return int
   **************************************************************************/
  [[nodiscard]] int better_main([[maybe_unused]] std::span<const std::string_view> args) noexcept;

} // namespace aiaa::project

#endif // AIAA_PROJECT_LIB_HPP
