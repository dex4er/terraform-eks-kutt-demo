// Based on https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/pull/86

const AWS = require("aws-sdk");

/**
 * This is a template for creating an AWS Secrets Manager rotation lambda
 * Mostly a translation of https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
 *
 * @summary Secrets Manager Rotation Template
 * @param {string} event Lambda dictionary of event parameters. These keys must include the following:
 *          - SecretId: The secret ARN or identifier
 *          - ClientRequestToken: The ClientRequestToken of the secret version
 *          - Step: The rotation step (one of createSecret, setSecret, testSecret, or finishSecret)
 * @param {LambdaContext} context The Lambda runtime information
 *
 * @throws {ValueError} If the secret is not properly configured for rotation
 * @throws {AWS.AWSError} If the secret with the specified arn and stage does not exist
 */
exports.handler = async (event, context, callback) => {
  const arn = event.SecretId;
  const token = event.ClientRequestToken;
  const step = event.Step;

  const endpoint = process.env.SECRETS_MANAGER_ENDPOINT;

  // Setup the client
  const secretsClient = new AWS.SecretsManager({
    endpoint,
  });

  // Make sure the version is staged correctly
  const metadata = await secretsClient
    .describeSecret({
      SecretId: arn,
    })
    .promise();

  if (!metadata["RotationEnabled"]) {
    console.info(`Secret ${arn} is not enabled for rotation`);
    throw new ValueError(`Secret ${arn} is not enabled for rotation`);
  }

  const versions = metadata.VersionIdsToStages;
  if (!versions[token]) {
    console.info(
      `Secret version ${token} has no stage for rotation of secret ${arn}.`
    );
    throw new ValueError(
      `Secret version ${token} has no stage for rotation of secret ${arn}.`
    );
  }

  if (versions[token].find((v) => v === "AWSCURRENT")) {
    console.info(
      `Secret version ${token} already set as AWSCURRENT for secret ${arn}.`
    );
    return;
  } else if (!versions[token].find((v) => v === "AWSPENDING")) {
    console.info(
      `Secret version ${token} not set as AWSPENDING for rotation of secret ${arn}.`
    );
    throw new ValueError(
      `Secret version ${token} not set as AWSPENDING for rotation of secret ${arn}.`
    );
  }

  switch (step) {
    case "createSecret":
      await createSecret(secretsClient, arn, token);
      return;
    case "setSecret":
      await setSecret(secretsClient, arn, token);
      return;
    case "testSecret":
      await testSecret(secretsClient, arn, token);
      return;
    case "finishSecret":
      await finishSecret(secretsClient, arn, token);
      return;
  }

  throw new ValueError("Invalid step parameter");
};

/**
 * This method first checks for the existence of a secret for the passed in token. If one does not exist, it will generate a
 * new secret and put it with the passed in token.
 *
 * @summary Create the secret
 * @param {AWS.SecretsManager} secretsClient The secrets manager service client
 * @param {string} arn The secret ARN or other identifier
 * @param {string} token The ClientRequestToken associated with the secret version
 * @throws {AWS.AWSError} If the secret with the specified arn and stage does not exist
 */
async function createSecret(secretsClient, arn, token) {
  // Make sure the current secret exists
  await secretsClient
    .getSecretValue({
      SecretId: arn,
      VersionStage: "AWSCURRENT",
    })
    .promise();

  // Now try to get the secret version, if that fails, put a new secret
  try {
    await secretsClient
      .getSecretValue({
        SecretId: arn,
        VersionId: token,
        VersionStage: "AWSPENDING",
      })
      .promise();
    console.info(`createSecret: Successfully retrieved secret for ${arn}.`);
  } catch (e) {
    const ExcludeCharacters = process.env.EXCLUDE_CHARACTERS || undefined;
    const PasswordLength = Number(process.env.PASSWORD_LENGTH) || undefined;
    // Generate a random password
    const password = await secretsClient
      .getRandomPassword({
        PasswordLength,
        ExcludeCharacters,
      })
      .promise();

    // Put the secret
    await secretsClient
      .putSecretValue({
        SecretId: arn,
        ClientRequestToken: token,
        SecretString: password.RandomPassword,
        VersionStages: ["AWSPENDING"],
      })
      .promise();
    console.info(
      `createSecret: Successfully put secret for ARN ${arn} and version ${token}.`
    );
  }
}

/**
 * This method should set the AWSPENDING secret in the service that the secret belongs to. For example, if the secret is a database
 * credential, this method should take the value of the AWSPENDING secret and set the user's password to this value in the database.
 *
 * @summary Set the secret
 * @param {AWS.SecretsManager} secretsClient - The secrets manager service client
 * @param {string} arn - The secret ARN or other identifier
 * @param {string} token - The ClientRequestToken associated with the secret version
 */
function setSecret(secretsClient, arn, token) {
  // Empty
}

/**
 * This method should validate that the AWSPENDING secret works in the service that the secret belongs to. For example, if the secret
 * is a database credential, this method should validate that the user can login with the password in AWSPENDING and that the user has
 * all of the expected permissions against the database.
 *
 * @summary Test the secret
 * @param {AWS.SecretsManager} secretsClient - The secrets manager service client
 * @param {string} arn - The secret ARN or other identifier
 * @param {string} token - The ClientRequestToken associated with the secret version
 */
function testSecret(secretsClient, arn, token) {
  // Empty
}

/**
 * This method finalizes the rotation process by marking the secret version passed in as the AWSCURRENT secret.
 *
 * @summary Finish the secret
 * @param {AWS.SecretsManager} secretsClient - The secrets manager service client
 * @param {string} arn - The secret ARN or other identifier
 * @param {string} token - The ClientRequestToken associated with the secret version
 * @throws {AWS.AWSError} If the secret with the specified arn does not exist
 */
async function finishSecret(secretsClient, arn, token) {
  // First describe the secret to get the current version
  const metadata = await secretsClient
    .describeSecret({
      SecretId: arn,
    })
    .promise();
  let currentVersion;
  for (let version of Object.keys(metadata.VersionIdsToStages)) {
    if (metadata.VersionIdsToStages[version].find((v) => v === "AWSCURRENT")) {
      if (version == token) {
        // The correct version is already marked as current, return
        console.info(
          `finishSecret: Version ${version} already marked as AWSCURRENT for ${arn}`
        );
        return;
      }
      currentVersion = version;
      break;
    }
  }

  // Finalize by staging the secret version current
  await secretsClient
    .updateSecretVersionStage({
      SecretId: arn,
      VersionStage: "AWSCURRENT",
      MoveToVersionId: token,
      RemoveFromVersionId: currentVersion,
    })
    .promise();
  console.info(
    `finishSecret: Successfully set AWSCURRENT stage to version ${token} for secret ${arn}.`
  );

  const RotateAfterDays = Number(process.env.ROTATE_AFTER_DAYS) || 0;

  // Disable rotation
  if (RotateAfterDays == 0) {
    await secretsClient
      .cancelRotateSecret({
        SecretId: arn,
      })
      .promise();
    console.info(
      `finishSecret: Successfully cancelled rotation for secret ${arn}.`
    );
  }
}

class ValueError extends Error {
  constructor(message) {
    super(message);
    this.name = "ValueError";
  }
}
