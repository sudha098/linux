import subprocess

def run_command(command):
    result = subprocess.run(
        command,
        shell=True,
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

if __name__ == "__main__":
    cmd = input("Enter the command:\n")
    output = run_command(cmd)

    if output:
        print(output)
    else:
        print("No output")
