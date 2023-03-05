*** Settings ***
Documentation           Library itself sample: https://github.com/bulkan/robotframework-requests/blob/master/tests/testcase.robot
...                     GitHub API's Doc: https://developer.github.com/v3/
Library                 RequestsLibrary
Library                 Collections
Resource                ../variables/my_user_and_passwords.robot

*** Variables ***
${GITHUB_HOST}          https://api.github.com
${ISSUES_URI}           repos/Liandro73/auditeste-mobile/issues

*** Keywords ***
Connect to GitHub API with authentication for token
    ${HEADERS}          Create Dictionary    Authorization=Bearer ${MY_GITHUB_TOKEN}
    Create Session      alias=mygithubAuth   url=${GITHUB_HOST}     headers=${HEADERS}     disable_warnings=True

Fill my user data
    ${MY_USER_DATA}     Get On Session       alias=mygithubAuth   url=/user
    Log                 Meus dados: ${MY_USER_DATA.json()}
    Check request response   ${MY_USER_DATA}

Connect to GitHub API without authentication
    Create Session      alias=mygithub       url=${GITHUB_HOST}     disable_warnings=True

Search issues with state "${STATE}" and label "${LABEL}"
    &{PARAMS}           Create Dictionary    state=${STATE}       labels=${LABEL}
    ${MY_ISSUES}        Get On Session       alias=mygithub       url=${ISSUES_URI}    params=${PARAMS}
    Log                 Lista de Issues: ${MY_ISSUES.json()}
    Check request response   ${MY_ISSUES}

Send the "${REACTION}" reaction to issue number "${ISSUE_NUMBER}"
    ${HEADERS}          Create Dictionary    Accept=application/vnd.github.squirrel-girl-preview+json
    ${MY_REACTION}      Post On Session      alias=mygithubAuth    url=${ISSUES_URI}/${ISSUE_NUMBER}/reactions
    ...                                      data={"content": "${REACTION}"}     headers=${HEADERS}
    Log                 Meus dados: ${MY_REACTION.json()}
    Check request response   ${MY_REACTION}

Check request response
    [Arguments]         ${RESPONSE}
    Should Be True      '${RESPONSE.status_code}'=='200' or '${RESPONSE.status_code}'=='201'
    ...                 msg=Erro na requisição! Verifique: ${RESPONSE}