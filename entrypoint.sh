#!/bin/sh

role_arn=$AWS_ROLE_ARN
session_name=${AWS_SESSION_NAME:-${DRONE_REPO//\//-}}

if [ -n "$role_arn" ]; then
    echo ">>> Assuming role..."
    sts=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name" --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)
    export AWS_ACCESS_KEY_ID=$(echo $sts | cut -d' ' -f1)
    export AWS_SECRET_ACCESS_KEY=$(echo $sts | cut -d' ' -f2)
    export AWS_SESSION_TOKEN=$(echo $sts | cut -d' ' -f3)
fi

exec /bin/drone-s3 "$@"
