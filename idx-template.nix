# idx-template.nix
# Parameters from idx-template.json are passed here.
# We provide default values matching those in idx-template.json just in case.
{ pkgs,
  googleCloudProject, # Required, so no default here
  apiServiceName ? "go-hello-world-api",
  logLevel ? "INFO",
  port ? "8080",
  ...
}: {
  # Packages needed for the bootstrap script itself (e.g., git, jq).
  # For simple file copying and echo, default pkgs.bash is usually enough.
  packages = [
    pkgs.bash # Ensures bash is available
  ];

  # The core bootstrap script.
  # This script is executed in a temporary directory containing a checkout
  # of your template repository.
  # "" is the path to the new workspace's root directory.
  bootstrap = ''
    set -e # Exit immediately if a command exits with a non-zero status.
    echo "🚀 Starting Go Cloud Run API template bootstrapping..."

    # 1. Copy all files from the template repository's current directory to 
    #    The expression ${./.} refers to the path of the directory containing this idx-template.nix file.
    echo "Copying project files from ${./.} to ..."
    # Using rsync is robust for copying, excluding .git from the template repo itself.
    # Or use 'cp -rT ${./.} ""' but manage exclusions manually.
    # For simplicity with cp and specific exclusions:
    mkdir -p ""
    shopt -s dotglob # Ensure dotfiles (like .gitignore, .vscode) are copied
    # List files to copy, excluding template-specific ones and .git from template repo
    # This is a bit manual; a common pattern is to copy everything then remove.
    for item in $(ls -A ${./.}); do
      if [[ "$item" != ".git" && "$item" != "idx-template.json" && "$item" != "idx-template.nix" && "$item" != "README-TEMPLATE.md" ]]; then
        cp -R "${./.}/$item" "/"
      fi
    done
    shopt -u dotglob

    # Ensure the new workspace directory is writable
    chmod -R +w ""
    echo "Project files copied."

    # 2. Create the .env file in the new workspace based on user parameters.
    #    Your application (internal/config/config.go) reads these.
    echo "Creating .env file with user-provided parameters in /.env..."
    cat <<ENV_EOF > "/.env"
GOOGLE_CLOUD_PROJECT=${googleCloudProject}
API_SERVICE_NAME=${apiServiceName}
LOG_LEVEL=${logLevel}
PORT=${port}
ENV_EOF
    echo ".env file created."

    # 3. (Optional) Modify .gitignore if needed for generated files, though your current one is good.
    #    Example: echo ".another-generated-file" >> "/.gitignore"

    # 4. (Crucial) Ensure the .idx/dev.nix from your template is in /.idx/dev.nix
    #    This was handled by the copy step above if .idx/dev.nix exists in your template repo.
    #    If you needed to *generate* dev.nix based on parameters, you'd do it here.
    #    For your project, copying the existing one is correct.
    if [ -f "/.idx/dev.nix" ]; then
      echo ".idx/dev.nix found in the new workspace."
    else
      echo "⚠️ WARNING: .idx/dev.nix was not found in the copied files. This is critical for the workspace environment."
      # You might want to fail here or provide a default one.
    fi

    # 5. (Optional) Initialize a new Git repository in the workspace for the user.
    # if type -P git; then
    #   echo "Initializing a new Git repository in ..."
    #   cd ""
    #   git init
    #   git add .
    #   git commit -m "Initial project setup from Firebase Studio template"
    #   cd -
    # else
    #   echo "Git not found in bootstrap environment, skipping git init for user."
    # fi

    echo "🎉 Go Cloud Run API template bootstrapping complete!"
    echo "Workspace ID: $WS_NAME" # WS_NAME is an available environment variable
  '';
}
