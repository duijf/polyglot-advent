#include <stdio.h>
#include <stdlib.h>


int main() {
    FILE *f = fopen("input", "rb");

    // Get the file size by seeking to the end, asking for the file
    // position and resetting to the beginning.
    fseek(f, 0, SEEK_END);
    long file_size = ftell(f);
    rewind(f);

    // Create a space for the contents of the file on the heap. Leave
    // room for the final string termination character (`\0`).
    char *contents = malloc(file_size + 1);
    size_t read_size = 1;
    size_t _bytes_read = fread(contents, read_size, file_size, f);

    fclose(f);
    contents[file_size] = 0;

    puts(contents);

    return 0;
}
