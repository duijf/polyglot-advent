import java.io.*;
import java.nio.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.util.List;

class Solution {
    public static void main(String[] args) throws IOException {
        Path input = FileSystems.getDefault().getPath("input");
        List<String> lines = Files.readAllLines(input, StandardCharsets.UTF_8);
    }
}
