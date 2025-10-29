from flask import Flask, render_template, request
from PIL import Image
import tensorflow as tf
import numpy as np
import io
import subprocess

app = Flask(__name__)
categories = ["Apple___Apple_scab",
              "Apple___Black_rot",
              "Apple___Cedar_apple_rust",
              "Apple___healthy",
              "Blueberry___healthy",
              "Cherry_(including_sour)___Powdery_mildew",
              "Cherry_(including_sour)___healthy",
              "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot",
              "Corn_(maize)___Common_rust_",
              "Corn_(maize)___Northern_Leaf_Blight",
              "Corn_(maize)___healthy",
              "Grape___Black_rot",
              "Grape___Esca_(Black_Measles)",
              "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)",
              "Grape___healthy",
              "Orange___Haunglongbing_(Citrus_greening)",
              "Peach___Bacterial_spot",
              "Peach___healthy",
              "Pepper,_bell___Bacterial_spot",
              "Pepper,_bell___healthy",
              "Potato___Early_blight",
              "Potato___Late_blight",
              "Potato___healthy",
              "Raspberry___healthy",
              "Soybean___healthy",
              "Squash___Powdery_mildew",
              "Strawberry___Leaf_scorch",
              "Strawberry___healthy",
              "Tomato___Bacterial_spot",
              "Tomato___Early_blight",
              "Tomato___Late_blight",
              "Tomato___Leaf_Mold",
              "Tomato___Septoria_leaf_spot",
              "Tomato___Spider_mites Two-spotted_spider_mite",
              "Tomato___Target_Spot",
              "Tomato___Tomato_Yellow_Leaf_Curl_Virus",
              "Tomato___Tomato_mosaic_virus",
              "Tomato___healthy"]
# Load the pre-trained model
model = tf.keras.models.load_model('leaf.h5')
process = None


# Define the image transformations
def preprocess_image(image):
    image = image.resize((256, 256))
    image = np.array(image) / 255.0
    image = np.expand_dims(image, axis=0)
    return image


@app.route('/', methods=['GET', 'POST'])
def index():
    global process
    if request.method == 'POST':
        if 'start' in request.form:
            if process is None or process.poll() is not None:
                # Start the process (run 2.py)
                process = subprocess.Popen(['python', '2.py'])
                return "Process started successfully."
            else:
                return "Process is already running."

        elif 'stop' in request.form:
            if process is not None and process.poll() is None:
                # Stop the process
                process.terminate()
                process.wait()
                return "Process stopped successfully."
            else:
                return "Process is not running."

        else:
            # Get the uploaded file from the form
            file = request.files['file']

            # Read the image file and preprocess it
            img = Image.open(io.BytesIO(file.read()))
            img = preprocess_image(img)

            # Make a prediction using the model
            prediction = model.predict(img)
            predicted_class = np.argmax(prediction)

            # Pass the predicted class to the result page
            return render_template('result.html', predicted_class=categories[predicted_class])

    return render_template('index.html')


if __name__ == '__main__':
    app.run()
