#pragma once

/// ###########################################################################
/// @section C++ 98/03
/// ###########################################################################

/// ===========================================================================
/// @subsection Utilities library
/// ===========================================================================

#include <bitset>     // std::bitset class template
#include <csignal>    // Functions and macro constants for signal management
#include <cstdarg>    // Handling of variable length argument lists
#include <functional> // Function objects, Function invocations, Bind operations and Reference wrappers
#include <typeinfo>   // Runtime type information utilities
#include <utility>    // Various utility components

/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/// @subsubsection Dynamic memory management
/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#include <memory> // High-level memory management utilities
#include <new>    // Low-level memory management utilities

/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/// @subsubsection Numeric limits
/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#include <climits> // Limits of integral types
#include <limits>  // Uniform way to query properties of arithmetic types

/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/// @subsubsection Error handling
/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#include <cassert>   // Conditionally compiled macro that compares its argument to zero
#include <cerrno>    // Macro containing the last error number
#include <exception> // Exception handling utilities
#include <stdexcept> // Standard exception objects

/// ===========================================================================
/// @subsection Strings library
/// ===========================================================================

#include <cstring> // Various narrow character string handling functions
#include <string>  // std::basic_string class template

/// ===========================================================================
/// @subsection Containers library
/// ===========================================================================

#include <deque>  // std::deque container
#include <list>   // std::list container
#include <map>    // std::map and std::multimap associative containers
#include <queue>  // std::queue and std::priority_queue container adaptors
#include <set>    // std::set and std::multiset associative containers
#include <stack>  // std:: stack container adaptor
#include <vector> // std::vector container

/// ===========================================================================
/// @subsection Iterators library
/// ===========================================================================

#include <iterator> // Range iterators

/// ===========================================================================
/// @subsection Algorithms library
/// ===========================================================================

#include <algorithm> // Algorithms that operate on ranges

/// ===========================================================================
/// @subsection Numerics library
/// ===========================================================================

#include <cmath>    // Common mathematics functions
#include <complex>  // Complex number type
#include <numeric>  // Numeric operations on values in ranges
#include <valarray> // Class for representing and manipulating arrays of values

/// ===========================================================================
/// @subsection Localization library
/// ===========================================================================

#include <clocale> // C localization utilities
#include <locale>  // Localization utilities

/// ===========================================================================
/// @subsection Input/Output library
/// ===========================================================================

#include <cstdio>   // C-style input-output functions
#include <fstream>  // std::basic_fstream, et. al class templates and typedefs
#include <iomanip>  // Helper functions to contro the format of input and output
#include <iostream> // Several standard stream objects (i.e. <ios> <istream> ...)
#include <sstream>  // std::basic_stringstream, et. al class templates and typedefs

/// ###########################################################################
/// @section C++ 11
/// ###########################################################################

#if defined(__cplusplus) || defined(_MSVC_LANG)

#if __cplusplus >= 201103L || _MSVC_LANG >= 201103L

/// ===========================================================================
/// @subsection Utilities library
/// ===========================================================================

#include <chrono>           // C++ time utilities
#include <initializer_list> // std::initializer_list class template
#include <tuple>            // std::tuple class template
#include <type_traits>      // Compile-time type information

/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/// @subsubsection Numeric limits
/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#include <cstdint> // Fixed-width integer types and limits of other types

/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/// @subsubsection Error handling
/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#include <system_error> // Defines std::error_code, a platform-dependent error code

/// ===========================================================================
/// @subsection Containers library
/// ===========================================================================

#include <array>         // std::array container
#include <forward_list>  // std::forward_list container
#include <unordered_map> // std::unordered_map and std::unordered_multimap unordered associative containers
#include <unordered_set> // std::unordered_set and std::unordered_multiset unordered associative containers

/// ===========================================================================
/// @subsection Numerics library
/// ===========================================================================

#include <random> // Random number generators and distributions
#include <ratio>  // Compile-time rational arithmetic

/// ===========================================================================
/// @subsection Regular Expressions library
/// ===========================================================================

#include <regex> // Classes, algorithms and iterators to support regex processing

/// ===========================================================================
/// @subsection Atomic Operations library
/// ===========================================================================

#include <atomic> // Atomic operations library

/// ===========================================================================
/// @subsection Thread support library
/// ===========================================================================

#include <condition_variable> // Thread waiting conditions
#include <future>             // Primitives for asynchronous computations
#include <mutex>              // Mutual exclusion primitives
#include <thread>             // std::thread class and supporting functions

/// ###########################################################################
/// @section C++ 14
/// ###########################################################################

#if __cplusplus >= 201402L || _MSVC_LANG >= 201402L

/// ===========================================================================
/// @subsection Thread support library
/// ===========================================================================

#include <shared_mutex> // Shared mutual exclusion primitives

/// ###########################################################################
/// @section C++ 17
/// ###########################################################################

#if __cplusplus >= 201703L || _MSVC_LANG >= 201703L

/// ===========================================================================
/// @subsection Utilities library
/// ===========================================================================

#include <any>      // std::any class
#include <optional> // std::optional class template
#include <variant>  // std::variant class template

/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/// @subsubsection Dynamic memory management
/// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

/// ---------------------------------------------------------------------------
/// <memory_resource>
#if defined(__has_include)
#if __has_include(<memory_resource>)

#include <memory_resource> // Polymorphic allocators and memory resources

#endif // __has_include(<memory_resource>)

#if __has_include(<experimental/memory_resource>)

#include <experimental/memory_resource> // Polymorphic allocators and memory resources

#endif // __has_include(<experimental/memory_resource>)

#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ===========================================================================
/// @subsection Strings library
/// ===========================================================================

#include <charconv>    // std::to_chars and std::from_chars
#include <string_view> // std::basic_string_view class template

/// ===========================================================================
/// @subsection Algorithms library
/// ===========================================================================

#include <execution> // Predefined execution policies for parallel versions of the algorithms

/// ===========================================================================
/// @subsection Filesystem library
/// ===========================================================================

#include <filesystem> // std::path class and supporting functions

/// ###########################################################################
/// @section C++ 20
/// ###########################################################################

#if __cplusplus >= 202002L || _MSVC_LANG >= 202002L

/// ===========================================================================
/// @subsection Concepts library
/// ===========================================================================

/// ---------------------------------------------------------------------------
/// <concepts>
#if defined(__has_include)
#if __has_include(<concepts>)

#include <concepts> // Fundamental library concepts

#endif // __has_include(<concepts>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ===========================================================================
/// @subsection Coroutines library
/// ===========================================================================

/// ---------------------------------------------------------------------------
/// <coroutine>
#if defined(__has_include)
#if __has_include(<coroutine>)

#include <coroutine> // Coroutine support library

#endif // __has_include(<coroutine>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ===========================================================================
/// @subsection Utilities library
/// ===========================================================================

#include <compare> // Three-way comparison operator support

/// ---------------------------------------------------------------------------
/// <source_location>
#if defined(__has_include)
#if __has_include(<source_location>)

#include <source_location> // Supplies means to obtain source code location

#endif // __has_include(<source_location>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

#include <version> // Supplies implementation-dependent library information

/// ===========================================================================
/// @subsection Strings library
/// ===========================================================================

/// ---------------------------------------------------------------------------
/// <format>
#if defined(__has_include)
#if __has_include(<format>)

#include <format> // Formatting library including std::format

#endif // __has_include(<format>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ===========================================================================
/// @subsection Containers library
/// ===========================================================================

#include <span> // std::span view

/// ===========================================================================
/// @subsection Ranges library
/// ===========================================================================

#include <ranges> // Range access, primitives, requirements, utilities and adaptors

/// ===========================================================================
/// @subsection Numerics library
/// ===========================================================================

#include <bit>     // Bit manipulation functions
#include <numbers> // Math constants

/// ===========================================================================
/// @subsection Thread support library
/// ===========================================================================

/// ---------------------------------------------------------------------------
/// <barrier>
#if defined(__has_include)
#if __has_include(<barrier>)

#include <barrier> // Barriers

#endif // __has_include(<barrier>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ---------------------------------------------------------------------------
/// <latch>
#if defined(__has_include)
#if __has_include(<latch>)

#include <latch> // Latches

#endif // __has_include(<latch>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ---------------------------------------------------------------------------
/// <semaphore>
#if defined(__has_include)
#if __has_include(<semaphore>)

#include <semaphore> // Semaphores

#endif // __has_include(<semaphore>)
#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

/// ---------------------------------------------------------------------------
/// <stop_token>
#if defined(__has_include)
#if __has_include(<stop_token>)

#include <stop_token> // Stop tokens for std::jthread

#endif // __has_include(<stop_token>)

#if __has_include(<experimental/stop_token>)

#include <experimental/stop_token> // Stop tokens for std::jthread

#endif // __has_include(<experimental/stop_token>)

#endif // defined (__has_include)
/// ---------------------------------------------------------------------------

#endif // __cplusplus >= 201103L || _MSVC_LANG >= 201103L
#endif // __cplusplus >= 201402L || _MSVC_LANG >= 201402L
#endif // __cplusplus >= 201703L || _MSVC_LANG >= 201703L
#endif // __cplusplus >= 202002L || _MSVC_LANG >= 202002L

#endif // defined(__cplusplus) || defined(_MSVC_LANG)
