# clone-it-all

`clone-it-all` is a script for cloning all repositories from a specified GitHub user or organization. By default, it clones only non-forked repositories, but you can optionally include forked repositories with the `--with-forks` flag.

## Features

-   Clone all repositories from a GitHub user or organization.
-   Optionally include forked repositories with `--with-forks`.

> [!IMPORTANT]
> This script requires the GitHub CLI (`gh`) to work. You need to have the GitHub CLI installed and authenticated on your system (`gh auth login`).

## Installation

1. **Install GitHub CLI:**

    Follow the [installation instructions for GitHub CLI](https://cli.github.com/) to install `gh`.

2. **Download the Script:**

    You can download the script directly from the repository or use `curl` to fetch it.

    ```bash
    sudo curl -L -o /usr/local/bin/clone-it-all https://raw.githubusercontent.com/MohammadxAli/clone-it-all/main/clone-it-all.sh
    ```

3. **Make the Script Executable:**

    Ensure the script has execute permissions:

    ```bash
    sudo chmod +x /usr/local/bin/clone-it-all
    ```

4. **Verify Installation:**

    Check that the script is available globally:

    ```bash
    clone-it-all
    ```

## Usage

### Basic Usage

To clone all non-fork repositories from a specified GitHub user or organization:

```bash
clone-it-all <github-username-or-organization> [output-folder]
```

-   `<github-username-or-organization>`: The GitHub username or organization from which to clone repositories.
-   `[output-folder]`: (Optional) The folder where repositories will be cloned. If not provided, a folder named after the GitHub username or organization will be created in the current directory.

### Example

Clone all repositories from `someusername` into a folder named `someusername` in the current directory:

```bash
clone-it-all someusername
```

### Including Forks

To include forked repositories in the clone operation, use the `--with-forks` flag:

```bash
clone-it-all <github-username-or-organization> [output-folder] --with-forks
```

### Example

Clone all repositories, including forks, from `someusername` into `/path/to/output-folder`:

```bash
clone-it-all someusername /path/to/output-folder --with-forks
```

## Options

-   `--with-forks`: Include forked repositories in the cloning process. By default, forks are ignored.
