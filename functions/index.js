/**
 * Firebase Cloud Function to handle Wali response updates
 * via a GET request with query parameters (user, email, status).
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Initialize Express app
const app = express();

// Enable CORS for all origins (for web access)
app.use(cors({origin: true}));

/**
 * GET endpoint to process wali response
 * Example: /response?user=USER_ID&email=w@example.com&status=accepted
 */
app.get("/response", async (req, res) => {
  const {user, email, status} = req.query;

  // Validate query params
  if (!user || !email || !status) {
    return res.status(400).send("Missing parameters.");
  }

  try {
    // Reference to user document
    const userRef = admin.firestore().collection("users").doc(user);
    const doc = await userRef.get();

    // Check if user exists
    if (!doc.exists) {
      return res.status(404).send("User not found.");
    }

    // Get wali list from user document
    const walis = doc.data().walis || [];

    // Update the status of the matched wali
    const updatedWalis = walis.map((wali) =>
      wali.email === email ? {...wali, status} : wali,
    );

    // Save back updated wali list
    await userRef.update({walis: updatedWalis});

    return res.send(
        `Thank you! Your response has been recorded as "${status}".`,
    );
  } catch (error) {
    console.error("Error processing response:", error);
    return res.status(500).send("Internal Server Error.");
  }
});

// Export the Express app as a Firebase function
exports.api = functions.https.onRequest(app);
