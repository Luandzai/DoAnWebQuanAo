const { Client } = require("@gradio/client");

// 1. Global variable to hold the Gradio client connection
let gradioApp;

// Helper function to create a delay
const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/**
 * Lazily connects to the Gradio space and returns the singleton client instance.
 * If the connection fails, it will be retried on the next request.
 * @returns {Promise<object>} The Gradio client instance.
 */
const getGradioApp = async () => {
  if (!gradioApp) {
    console.log("Connecting to Gradio space: yisol/IDM-VTON...");
    try {
      // THAY ĐỔI Ở ĐÂY: Thêm object chứa hf_token vào tham số thứ 2
      gradioApp = await Client.connect("yisol/IDM-VTON", {
        hf_token: process.env.HF_TOKEN,
      });

      console.log("Gradio connection established successfully.");
    } catch (error) {
      console.error("Failed to connect to Gradio:", error.message);
      gradioApp = null;
      throw error;
    }
  }
  return gradioApp;
};

const handleTryOn = async (req, res) => {
  try {
    // Validate that file buffers exist
    if (
      !req.files ||
      !req.files.personImage ||
      !req.files.personImage[0].buffer ||
      !req.files.clothImage ||
      !req.files.clothImage[0].buffer
    ) {
      const error = new Error(
        "Vui lòng tải lên đủ cả ảnh người và ảnh trang phục."
      );
      error.statusCode = 400;
      throw error;
    }

    // 2. Get the persistent Gradio client connection
    const app = await getGradioApp();

    const personBuffer = req.files.personImage[0].buffer;
    const clothBuffer = req.files.clothImage[0].buffer;

    const personBlob = new Blob([personBuffer]);
    const clothBlob = new Blob([clothBuffer]);

    const predictArgs = [
      { background: personBlob, layers: [], composite: null },
      clothBlob,
      "clothing",
      true,
      false,
      30,
      42,
    ];

    let lastError;
    let result;

    // 3. Retry logic for the prediction call
    for (let attempt = 1; attempt <= 3; attempt++) {
      try {
        console.log(`Prediction attempt ${attempt}...`);
        result = await app.predict("/tryon", predictArgs);
        console.log("Prediction successful.");
        lastError = null; // Clear error on success
        break; // Exit loop
      } catch (error) {
        console.error(`Attempt ${attempt} failed:`, error.message);
        lastError = error;
        // If the connection seems to have dropped, reset the client for the next request
        if (
          error.message.includes("Could not connect") ||
          error.message.includes("fetch failed")
        ) {
          gradioApp = null;
        }
        if (attempt < 3) {
          console.log("Waiting 2 seconds before retrying...");
          await delay(2000);
        }
      }
    }

    // If all retries failed, throw the last recorded error
    if (lastError) {
      throw lastError;
    }

    if (
      result &&
      result.data &&
      Array.isArray(result.data) &&
      result.data.length > 0
    ) {
      const outputUrl = result.data[0].url;
      if (outputUrl) {
        return res.json({ resultUrl: outputUrl });
      }
    }

    throw new Error("API did not return a valid result URL after retries.");
  } catch (error) {
    console.error("Lỗi khi xử lý thử đồ ảo (sau khi thử lại):", error);
    res.status(error.statusCode || 500).json({
      message: error.message || "Đã có lỗi xảy ra từ server khi thử đồ.",
    });
  }
};

module.exports = { handleTryOn };
