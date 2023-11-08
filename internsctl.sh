#!/bin/bash

# Function to display the manual page
function display_manual() {
  echo "internsctl - Custom Linux Command"
  echo "Version: v0.1.0"
  echo
  echo "DESCRIPTION:"
  echo "  internsctl is a custom Linux command to perform various system operations."
  echo
  echo "OPTIONS:"
  echo "  cpu getinfo        Get CPU information (similar to lscpu)"
  echo "  memory getinfo     Get memory information (similar to free)"
  echo "  user create        Create a new user"
  echo "  user list          List all regular users"
  echo "  user list --sudo-only List users with sudo permissions"
  echo "  file getinfo       Get information about a file"
  echo
  echo "For more details, use 'internsctl <command> --help'"
}

# Function to display help for specific commands
function display_command_help() {
  case "$1" in
    "cpu")
      echo "cpu getinfo - Get CPU information (similar to lscpu)"
      ;;
    "memory")
      echo "memory getinfo - Get memory information (similar to free)"
      ;;
    "user")
      echo "user create <username> - Create a new user"
      echo "user list - List all regular users"
      echo "user list --sudo-only - List users with sudo permissions"
      ;;
    "file")
      echo "file getinfo <file-name> - Get information about a file"
      echo "Options:"
      echo "  --size, -s     Print size of the file"
      echo "  --permissions, -p  Print file permissions"
      echo "  --owner, -o   Print file owner"
      echo "  --last-modified, -m Print last modified time"
      ;;
    *)
      echo "Invalid command. Use 'internsctl --help' for usage."
      ;;
  esac
}

# Function to get CPU information
function get_cpu_info() {
  lscpu
}

# Function to get memory information
function get_memory_info() {
  free
}

# Function to create a new user
function create_user() {
  if [ -z "$1" ]; then
    echo "Error: Missing username. Usage: internsctl user create <username>"
  else
    sudo useradd -m "$1"
    sudo passwd "$1"
  fi
}

# Function to list users
function list_users() {
  if [ "$1" == "--sudo-only" ]; then
    getent passwd | grep -E 'sudo|admin'
  else
    getent passwd
  fi
}

# Function to get file information
function get_file_info() {
  local file="$1"
  local option="$2"

  if [ -z "$file" ]; then
    echo "Error: Missing file name. Usage: internsctl file getinfo <file-name>"
  elif [ ! -e "$file" ]; then
    echo "Error: File does not exist."
  else
    case "$option" in
      "--size" | "-s")
        stat --format=%s "$file"
        ;;
      "--permissions" | "-p")
        stat --format=%A "$file"
        ;;
      "--owner" | "-o")
        stat --format=%U "$file"
        ;;
      "--last-modified" | "-m")
        stat --format=%y "$file"
        ;;
      *)
        echo "Invalid option. Use 'internsctl file getinfo --help' for usage."
        ;;
    esac
  fi
}

# Main script logic
case "$1" in
  "--help")
    display_manual
    ;;
  "--version")
    echo "internsctl v0.1.0"
    ;;
  "cpu")
    get_cpu_info
    ;;
  "memory")
    get_memory_info
    ;;
  "user")
    if [ "$2" == "--help" ]; then
      display_command_help "user"
    else
      create_user "$2"
    fi
    ;;
  "file")
    if [ "$2" == "--help" ]; then
      display_command_help "file"
    else
      get_file_info "$2" "$3"
    fi
    ;;
  *)
    echo "Invalid command. Use 'internsctl --help' for usage."
    ;;
esac

