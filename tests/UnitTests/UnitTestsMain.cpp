#include "Project/ProjectLib.hpp"

#include <gtest/gtest.h>

TEST(MainTestSuite, better_main) {
  std::vector<std::string_view> args;
  args.push_back("UnitTestsMain.exe");
  args.push_back("Hello");
  args.push_back("World");

  std::stringstream output;
  auto cout_buff = std::cout.rdbuf(); // save pointer to std::cout buffer
  std::cout.rdbuf(output.rdbuf());    // substitute internal std::cout buffer with buffer of output

  EXPECT_EQ(0, project::lib::better_main(args));
  EXPECT_EQ("UnitTestsMain.exe\nHello\nWorld\n\n", output.str());

  std::cout.rdbuf(cout_buff); // restore std::cout buffer
}

int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
