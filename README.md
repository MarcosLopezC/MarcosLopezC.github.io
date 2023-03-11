# MarcosLopezC.com website

This repository contains the source code for <https://www.MarcosLopezC.com>.

## Running locally

To run the code locally first install the Node.js.
To get an installer for Windows go to <https://nodejs.org/en/>.

After Node.js is installed, open a Terminal and navigate to the repository directory.
Then run the following command to install additional development tools:

```bash
npm run install
```

Once everything is installed, run `copy-library-files.sh` to copy the required library files to the `src/library` directory.

```bash
./copy-library-files.sh
```

To run a local server to test the code, run the following command:

```bash
npm run dev
```

## Build

To build the website, run the following command:

```bash
npm run build
```

## Deployment

This project is setup to automatically deploy whenever a commit is pushed to the `master` branch of this repository <https://github.com/MarcosLopezC/MarcosLopezC.github.io.git> using Github Actions.

To alter this behavior, edit this file: `.github/workflows/deploy.yml`.