*** Settings ***
Resource                ../resources/resource.robot

*** Test Cases ***
Sample 1: Basic Authentication
    Connect to GitHub API with authentication for token
    Fill my user data

Sample 2: Using parameters
    Connect to GitHub API without authentication
    Search issues with state "open" and label "bug"

Sample 3: Using headers
    Connect to GitHub API with authentication for token
    Send the "heart" reaction to issue number "1"