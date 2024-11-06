import os
import term

const script_name = os.base(os.executable())

fn main() {
	if os.args.len == 1 {
		help()
		return
	}

	match os.args[1] {
		'ft' { file_to_text() or { eprintln(term.red('Error: ${err}')) } }
		'tf' { text_to_file() or { eprintln(term.red('Error: ${err}')) } }
		'install' { install() or { eprintln(term.red('Error: ${err}')) } }
		'uninstall' { uninstall() or { eprintln(term.red('Error: ${err}')) } }
		'help' { help() }
		else { eprintln(term.red("Invalid option. Use 'convft help' for usage information.")) }
	}
}

fn help() {
	println(term.bold(term.blue('=======================================')))
	println(term.bold(term.blue('       ConvFT: File-Text Conversion     ')))
	println(term.bold(term.blue('=======================================')))
	println('')
	println(term.cyan('A simple CLI tool for converting between file structures'))
	println(term.cyan('and single text file representations. Ideal for backup,'))
	println(term.cyan('sharing, and reconstructing complex directory hierarchies.'))
	println('')
	println('${term.magenta('Repository:')} ${term.bold('https://github.com/Mik-TF/convft_v')}')
	println('')
	println('${term.yellow('Usage:')} ${term.bold('convft [OPTION]')}')
	println('')
	println(term.green('Options:'))
	println('  ${term.bold('ft')}         Convert files to text')
	println('  ${term.bold('tf')}         Convert text to files')
	println('  ${term.bold('install')}    Install ConvFT (requires sudo)')
	println('  ${term.bold('uninstall')}  Uninstall ConvFT (requires sudo)')
	println('  ${term.bold('help')}       Display this help message')
	println('')
	println(term.yellow('Examples:'))
	println('  ${term.bold('convft ft')}              # Convert current directory to \'all_files_text.txt\'')
	println('  ${term.bold('convft tf')}              # Reconstruct files from \'all_files_text.txt\'')
	println('  ${term.bold('sudo ./convft install')}    # Install ConvFT system-wide')
	println('  ${term.bold('sudo convft uninstall')}  # Remove ConvFT from the system')
	println('')
	println(term.blue('========================================='))
}

fn get_directory_tree() !string {
	// Check if tree command exists
	if os.system('which tree > /dev/null 2>&1') != 0 {
		return error('tree command not found. Please install it first.')
	}

	// Create a temporary file to store tree output
	temp_file := os.join_path(os.temp_dir(), 'tree_output.txt')
	defer {
		os.rm(temp_file) or {}
	}

	// Execute tree command and capture output
	os.system('tree -L 2 > ${temp_file}')

	// Read and return the output
	return os.read_file(temp_file)!
}

fn file_to_text() ! {
	output_file := 'all_files_text.txt'

	println(term.yellow('Starting conversion of files to text...'))

	// Initialize the output file
	os.write_file(output_file, '')!

	// Add directory tree at the beginning
	mut f := os.open_append(output_file)!
	f.write_string('DirectoryTree:\n')!
	tree_output := get_directory_tree()!
	f.write_string(tree_output)!
	f.write_string('EndDirectoryTree\n\n')!
	f.close()

	files := os.walk_ext('.', '')
	for file in files {
		abs_file := os.real_path(file)
		base_name := os.base(file)
		if abs_file != os.executable() && os.base(file) != output_file
			&& os.base(file) != script_name
			&& (os.file_ext(file) in ['.md', '.txt', '.py', '.rs', '.js', '.css', '.html', '.v']
			|| base_name in ['Makefile', 'makefile', 'GNUmakefile', 'LICENSE', 'License', 'COPYING']) {
			println(term.cyan('Processing:') + ' ${file}')
			mut content := 'Filepath: ${file}\nContent:\n'
			content += os.read_file(file)!
			content += '\n\n'
			mut f2 := os.open_append(output_file)!
			f2.write_string(content)!
			f2.close()
		}
	}

	println(term.green('Conversion completed. Output saved to ') + term.bold(output_file))
}

fn text_to_file() ! {
	input_file := 'all_files_text.txt'

	if !os.exists(input_file) {
		return error('${input_file} not found')
	}

	println(term.yellow('Starting conversion of text to files...'))

	content := os.read_file(input_file)!
	lines := content.split_into_lines()

	mut current_file := ''
	mut file_content := ''
	mut in_tree_section := false

	for line in lines {
		if line == 'DirectoryTree:' {
			in_tree_section = true
			continue
		}
		if line == 'EndDirectoryTree' {
			in_tree_section = false
			continue
		}
		if in_tree_section {
			continue
		}

		if line.starts_with('Filepath:') {
			if current_file != '' {
				create_file(current_file, file_content)!
				file_content = ''
			}
			current_file = line[9..].trim_space()
			// Ensure we only create files in the current directory or its subdirectories
			if !current_file.starts_with('./') && !current_file.starts_with('/') {
				current_file = './' + current_file
			}
			println(term.cyan('Creating:') + ' ${current_file}')
		} else if line != 'Content:' {
			file_content += line + '\n'
		}
	}

	if current_file != '' {
		create_file(current_file, file_content)!
	}

	println(term.green('Conversion completed. Files have been recreated.'))
}

fn create_file(path string, content string) ! {
	dir := os.dir(path)
	if dir != '' {
		os.mkdir_all(dir)!
	}
	os.write_file(path, content)!
}

fn install() ! {
	if os.getuid() != 0 {
		return error('Please run the install function with sudo.')
	}

	os.cp(os.executable(), '/usr/local/bin/convft')!
	os.chmod('/usr/local/bin/convft', 0o755)!

	println(term.green("Installation successful. You can now use 'convft' from any directory."))
}

fn uninstall() ! {
	if os.getuid() != 0 {
		return error('Please run the uninstall function with sudo.')
	}

	if os.exists('/usr/local/bin/convft') {
		os.rm('/usr/local/bin/convft')!
		println(term.green('ConvFT has been uninstalled successfully.'))
	} else {
		println(term.yellow('ConvFT is not installed in /usr/local/bin.'))
	}
}
