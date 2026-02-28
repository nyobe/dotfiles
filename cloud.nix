{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish.functions = {
    aws-env = ''
      if test -z "$argv[1]"
        echo "Exports AWS SSO credentials as environment variables in the current shell."
        echo ""
        echo "Usage: aws-env <profile>"
        echo ""
        echo "Available profiles:"
        aws configure list-profiles 2>/dev/null | string match -v 'default'
        return 1
      end

      set -l profile $argv[1]

      if not aws sts get-caller-identity --profile "$profile" &>/dev/null
        echo "Session expired, logging in..."
        aws sso login --profile "$profile"
      end

      set -l creds (aws configure export-credentials --profile "$profile" --format process)
      if test $status -ne 0
        echo "Failed to export credentials for $profile"
        return 1
      end

      set -gx AWS_ACCESS_KEY_ID (echo "$creds" | ${pkgs.jq}/bin/jq -r .AccessKeyId)
      set -gx AWS_SECRET_ACCESS_KEY (echo "$creds" | ${pkgs.jq}/bin/jq -r .SecretAccessKey)
      set -gx AWS_SESSION_TOKEN (echo "$creds" | ${pkgs.jq}/bin/jq -r .SessionToken)

      echo "Loaded credentials for $profile"
    '';

    aws-clear = ''
      set -e AWS_ACCESS_KEY_ID
      set -e AWS_SECRET_ACCESS_KEY
      set -e AWS_SESSION_TOKEN
      echo "Cleared AWS credentials"
    '';
  };
}