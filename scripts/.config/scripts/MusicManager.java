import java.io.FileNotFoundException;
import java.io.IOException;

import java.nio.file.attribute.BasicFileAttributes;

import java.nio.file.Files;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;

import java.util.ArrayList;
import java.util.List;

public class MusicManager {
	private Path musicDirectory;
	private Path androidMusicDirectory;

	public MusicManager(Path musicDirectory, Path androidMusicDirectory)
		throws FileNotFoundException {
		this.musicDirectory = musicDirectory;
		this.androidMusicDirectory = androidMusicDirectory;

		if (!isAdbInstalled()) {
			throw new FileNotFoundException("ADB is not installed.");
		}
	}

	private boolean isAdbInstalled() {
		String path = System.getenv("PATH");
		String[] installationDirectories = path.split(":");

		for (String directory : installationDirectories) {
			Path adb = Path.of(directory, "adb");
			if (Files.isRegularFile(adb) && Files.isExecutable(adb)) {
				return true;
			}
		}

		return false;
	}

	private String executeShellCommand(String... command) throws IOException {
		Process process = new ProcessBuilder(command)
			.redirectErrorStream(true)
			.start();
		return new String(process.getInputStream().readAllBytes());
	}

	public List<Path> findDownloadedSongs() throws IOException {
		List<Path> songsFound = new ArrayList<>();
		Files.walkFileTree(musicDirectory, new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
				songsFound.add(file);
				return FileVisitResult.CONTINUE;
			}
		});

		return songsFound;
	}

	public List<Path> findSongsOnPhone() throws IOException {
		String files = executeShellCommand("adb", "shell", "find", androidMusicDirectory.toString(), "-type", "f");

		if (files.contains("no devices/emulators found") || files.contains("device unauthorized")) {
			throw new IOException("Could not connect to device");
		}

		List<Path> songs = new ArrayList<>();
		for (String line : files.split("\n")) {
			songs.add(Path.of(line));
		}

		return songs;
	}

	public List<Path> findSongsNotCopied(List<Path> downloadedSongs, List<Path> songsOnPhone) {
		List<Path> songsNotCopied = new ArrayList<>();
		for (Path song : downloadedSongs) {
			boolean found = false;
			Path relativePath = musicDirectory.relativize(song);
			for (Path phoneSong : songsOnPhone) {
				Path phoneRelativePath = androidMusicDirectory.relativize(phoneSong);
				if (relativePath.equals(phoneRelativePath)) {
					found = true;
					break;
				}
			}
			if (!found) {
				songsNotCopied.add(song);
			}
		}

		return songsNotCopied;
	}

	public void push(List<Path> songs) throws IOException {
		for (Path song : songs) {
			Path relativePath = musicDirectory.relativize(song);
			Path targetPath = androidMusicDirectory.resolve(relativePath);
			Path targetParent = targetPath.getParent();

			if (targetParent != null) {
				executeShellCommand("adb", "shell", "mkdir", "-p", targetParent.toString());
			}
			executeShellCommand("adb", "push", song.toString(), targetPath.toString());
		}
	}

	public void pull(List<Path> songs) throws IOException {
		for (Path song : songs) {
			Path relativePath = androidMusicDirectory.relativize(song);
			Path targetPath = musicDirectory.resolve(relativePath);
			Path targetParent = targetPath.getParent();
			if (targetParent != null && !Files.exists(targetParent)) {
				Files.createDirectories(targetParent);
			}

			executeShellCommand("adb", "pull", song.toString(), targetPath.toString());
		}
	}

	public static void main(String[] args) throws IOException {
		try {
			if (args.length < 1) {
				System.err.println("Usage: MusicManager <push | pull>");
				return;
			}

			MusicManager musicManager = new MusicManager(
				Path.of(System.getProperty("user.home"), "Music"),
				Path.of("/storage/emulated/0/Music")
			);

			List<Path> downloadedSongs, songsOnPhone;
			try {
				downloadedSongs = musicManager.findDownloadedSongs();
				songsOnPhone = musicManager.findSongsOnPhone();
			} catch (IOException e) {
				System.err.println(e.getMessage());
				return;
			}

			switch (args[0]) {
				case "push":
					List<Path> songsNotCopied = musicManager.findSongsNotCopied(downloadedSongs, songsOnPhone);
					musicManager.push(songsNotCopied);
					break;
				case "pull":
					musicManager.pull(songsOnPhone);
					break;
				default:
					System.err.println("Usage: MusicManager <push | pull>");
					return;
			}
			
		} catch (FileNotFoundException e) {
			System.err.println(e.getMessage());
		}
	}
}