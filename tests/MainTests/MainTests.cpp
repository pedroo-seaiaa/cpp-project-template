/// ##########################################################################
/// @copyright Copyright (c) 2023, AI & ARTS Alchemy. All rights reserved.
/// ##########################################################################
#include "StandardLibrary.hpp"

#include "Project/ProjectLib.hpp"

#include <catch2/catch_test_macros.hpp>

/// ==========================================================================
/// @section Tests
/// ==========================================================================

SCENARIO("Project") {
  GIVEN("The executable, 'Hello' and 'World'") {
    std::vector<std::string_view> args;
    args.emplace_back("UnitTestsMain.exe");
    args.emplace_back("Hello");
    args.emplace_back("World");

    WHEN("better_main is called with those arguments") {
      std::stringstream output;
      auto* cout_buff = std::cout.rdbuf(); // save pointer to std::cout buffer
      std::cout.rdbuf(output.rdbuf());     // substitute internal std::cout buffer with buffer of output

      THEN("better_main should return 0 AND STDOUT should be 'UnitTestsMain.exe\nHello\nWorld\n\n'") {
        CHECK(0 == project::lib::better_main(args));
        CHECK("UnitTestsMain.exe\nHello\nWorld\n\n" == output.str());
      }

      std::cout.rdbuf(cout_buff); // restore std::cout buffer
    }
  }
}
