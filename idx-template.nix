# idx-template.nix
{ pkgs,
  googleCloudProject,
  apiServiceName ? "go-hello-world-api",
  logLevel ? "INFO",
  port ? "8080",
  ...
}: {
  packages = [
    pkgs.bash
  ];
  bootstrap = ''
    set -ex # Print commands and exit on error

    echo "--- TEMPLATE DEBUG START ---"
    echo "Attempting to diagnose \$out variable."
    echo "Value of out: [$out]"
    echo "Value of WS_NAME (Workspace Name): [$WS_NAME]"
    echo "Current working directory: $(pwd)"
    echo "Listing environment variables (env):"
    env | sort
    echo "--- TEMPLATE DEBUG END ---"

    echo "🚀 Starting Go Cloud Run API template bootstrapping (after debug)..."

    # Defensive check: if $out is empty, exit with an error message
    if [ -z "$out" ]; then
      echo "CRITICAL ERROR: The \$out variable is empty or not set. Cannot proceed."
      echo "This indicates an issue with the templating environment."
      exit 1
    fi

    echo "Copying project files from \${./.} to [$out] (verified \$out not empty)..."
    mkdir -p "$out"
    # Rest of your script...
    shopt -s dotglob
    for item in \$(ls -A \${./.}); do
      if [[ "\$item" != ".git" && "\$item" != "idx-template.json" && "\$item" != "idx-template.nix" && "\$item" != "README-TEMPLATE.md" ]]; then
        cp -R "\${./.}/\$item" "$out/"
      fi
    done
    shopt -u dotglob

    chmod -R +w "$out"
    echo "Project files copied."

    echo "Creating .env file with user-provided parameters in $out/.env..."
    cat <<ENV_EOF > "$out/.env"
GOOGLE_CLOUD_PROJECT=\${googleCloudProject}
API_SERVICE_NAME=\${apiServiceName}
LOG_LEVEL=\${logLevel}
PORT=\${port}
ENV_EOF
    echo ".env file created."

    if [ -f "$out/.idx/dev.nix" ]; then
      echo ".idx/dev.nix found in the new workspace."
    else
      echo "⚠️ WARNING: .idx/dev.nix was not found in the copied files."
    fi

    echo "🎉 Go Cloud Run API template bootstrapping complete!"
    echo "Workspace ID: \$WS_NAME"
  '';
}