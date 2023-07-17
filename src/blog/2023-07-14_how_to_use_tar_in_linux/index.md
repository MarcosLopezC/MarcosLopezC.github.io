Tar, short for _tape archive_, is an archive format commonly used in Linux for bundling and organizing files and directories.
In this article, I'll go over the basics needed to get started using this utility.

## About the Tar Format

Tar files have a simple structure.
They consist of a series of file entries concatenated together.
Each file entry represents a file or directory and contains metadata about the file, such as:
- name
- permissions
- owner
- group
- timestamp
- file size

The structure of a file entry typically includes the following components:

1. **Header:** The header section contains information about the file, including its name, permissions, timestamps, owner, group, file size, and other metadata.
The header is a fixed-size block that precedes each file entry.

2. **File Data:** Following the header is the actual file data, which represents the content of the file.
The file data section varies in size depending on the file's size.

3. **Padding:** Tar files use padding to align file data on block boundaries.
Padding ensures that each file entry occupies a multiple of a specific block size, typically 512 bytes.

4. **End of File Markers:** Tar files often end with two empty 512-byte blocks, indicating the end of the archive.

## Creating a Tar File

To create a Tar file, use the `tar` command with the `-cvf` flags followed by the desired name of the Tar file and the files or directories to include.
For example, to create a Tar file named `backup.tar` containing two files named `contacts.txt` and `config.txt`, run the following command:

```sh
tar -cvf backup.tar contacts.txt config.txt
```

Let's have a look at the flags:
- `-c` (or `--create`) tells `tar` to create a new archive.
- `-v` (or `--verbose`) tells `tar` to display detailed information about the files being processed.
When used with the `-c` flag, the verbose mode shows the names of the files being added to the archive.
- `-f` (or `--file`) tells `tar` the file name or device where the Tar archive will be stored.
This flag is necessary when creating or manipulating Tar files.

## Extracting Files From a Tar File

To extract the contents of a Tar file, use the `tar` command with the `xvf` flags followed by the name of the Tar file.
For example, to extract the file created in the previous section, run the following command:

```sh
tar -xvf backup.tar
```

The `-x` (or `--extract`) tells `tar` to extract the files from the Tar archive.

By default, the files will be extracted in the current working directory.

To specify a different extraction directory, use the `-C` (or `--directory`) flag followed by the desired path. For example, to extract the files to the home directory, run the following command:

```sh
tar -xvf backup.tar -C ~/
```

## Tar File Compression

A Tar file is effectively the result of concatenating multiple file entries, each containing metadata and file data, in a structured format.
To save on disk space, this file can be compressed using various compression algorithms such as GZIP or BZIP2, resulting in a compressed Tar archive.

For example, to create a compressed Tar file, the `tar` command can be combined with the `gzip` command:

```sh
tar -cvf backup.tar contacts.txt config.txt | gzip > backup.tar.gz
```

However, there is an easier way to do this.
When creating a Tar file, use the `-z` flag to tell `tar` to use GZIP compression.
For example, this command will result in the same output as the command above:

```sh
tar -cvzf backup.tar.gz contacts.txt config.txt
```

Similarly, to use BZIP2 compression, use the `-j` flag:

```sh
tar -cvjf backup.tar.bz2 contacts.txt config.txt
```

To decompress a Tar file, the `tar` command can automatically detect the compression format used from the file name extension.
For example:

```sh
tar -xf backup.tar.gz
```

In this case, the `tar` command recognizes the `.tar.gz` extension and automatically applies the appropriate decompression (in this case, GZIP) before extracting the files.

If a Tar file does not have an extension, the compression format cannot be determined solely based on its name.
In these cases, the `tar` command needs to be provided with the appropriate compression flag.
For example, to extract a Tar file named `backup` compressed using GZIP, use the following command:

```sh
tar -xzf backup
```

## Inspecting a Tar File

To see the contents of a Tar file, use the `tar` command with the `-tf` flag.
The `-t` (or `--list`) flag tells `tar` to list the contents of the Tar file without extracting them.
For example, to see the contents of Tar file from the previous examples, run the following command:

```sh
tar -tf backup.tar
```

## Adding to a Tar file

It is possible to append additional files or directories to an existing Tar file.
For example, the following command will append the file `numbers.txt` to `backup.tar`.

```sh
tar -rf backup.tar numbers.txt
```

The `-r` (or `--append`) flag tells `tar` to append the files and directories provided to the end of the Tar file.

Keep in mind that this operation is only appending a new file entry to the end of the Tar file.
When a file being appended has the same name as one already in the Tar file, the latest one will be used by default.
But the Tar file will contain both versions.

To extract a specific occurrence, use the `tar` command with the `--occurrence` flag.
For example:

```sh
tar -xf backup.tar --occurrence=2 numbers.txt
```

In this case, the `--occurrence` flag is used to tell `tar` to process the second occurrence of the file `numbers.txt` in `backup.tar`.

## Conclusion

The `tar` command has many more options that I won't explore here.
But this should be enough to get started using Tar in Linux.
