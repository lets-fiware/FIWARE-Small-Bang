# System administration

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Files and directories layout](#files-and-directories-layout)
-   [Make command for system administration](#make-command-for-system-administration)
-   [How to create environment for NGSI Go on another machine](#how-to-create-environment-for-ngsi-go-on-another-machine)
    -   [Setup NGSI Go](#setup-ngsi-go)

</details>

## Files and directories layout

The following files and directories will be created.

| File or directory    | Description                                                                             |
| -------------------- | --------------------------------------------------------------------------------------- |
| .                    | A root directory of FI-SB. It's a directory in which you ran setup-fiware.sh command.   |
| ./docker-compose.yml | A config file for docker compose which has the configuration information of FIWARE GEs. |
| ./.env               | A file which has environment variables for docker-compose.yml file.                     |
| ./Makefile           | A file for make command.                                                                |
| ./config             | A directory which has configuration files for running Docker containers.                |
| ./data               | A directory which has persistent data for running Docker containers.                    |
| ./setup\_ngsi\_go.sh | A script file to setup NGSI Go on another machine.                                      |

## Make command for system administration

You can manage your FIWARE instance with make command. Run the make command in a directory where you ran
the setup-fiware.sh script.

| Command       | Description                                                |
| ------------- | ---------------------------------------------------------- |
| ps            | List docker containers for FIWARE instance                 |
| up            | Start docker containers for FIWARE instance                |
| down          | Stop and remove docker containers for FIWARE instance      |
| clean         | !CAUTION! Clean up FIWARE instance including your all data |
| collect       | Collect system information                                 |
| info          | Print service URLs                                         |

## How to create environment for NGSI Go on another machine

### Setup NGSI Go

To setup NGSI Go on another machine, see here [https://github.com/lets-fiware/ngsi-go](https://github.com/lets-fiware/ngsi-go).
And copy and run the `setup_ngsi_go.sh` script on the machine. It asks you an admin email and a password.
