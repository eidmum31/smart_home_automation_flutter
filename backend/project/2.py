import urllib.request
import cv2
import numpy as np
from tensorflow.keras.models import load_model

# Load the saved model
model = load_model('leaf.h5')

url = 'http://192.168.0.101:8080/shot.jpg'
categories=['Pepper__bell___Bacterial_spot' ,'Pepper__bell___healthy',
 'Potato___Early_blight', 'Potato___Late_blight' ,'Potato___healthy',
 'Tomato_Bacterial_spot', 'Tomato_Early_blight', 'Tomato_Late_blight',
 'Tomato_Leaf_Mold', 'Tomato_Septoria_leaf_spot',
 'Tomato_Spider_mites_Two_spotted_spider_mite' ,'Tomato__Target_Spot',
 'Tomato__Tomato_YellowLeaf__Curl_Virus', 'Tomato__Tomato_mosaic_virus',
 'Tomato_healthy']
# Define the function for preprocessing the input frame
def preprocess_frame(frame):
    # Preprocess the frame as required by your model
    # For example, resize the frame to match the input size of your model
    preprocessed_frame = cv2.resize(frame, (256, 256))
    # Normalize the pixel values
    preprocessed_frame = preprocessed_frame.astype('float32') / 255.0
    # Expand dimensions to match the input shape expected by the model
    preprocessed_frame = np.expand_dims(preprocessed_frame, axis=0)
    return preprocessed_frame

while True:
    # Retrieve the image from the URL
    img_path = urllib.request.urlopen(url)
    img_np = np.array(bytearray(img_path.read()), dtype=np.uint8)
    img = cv2.imdecode(img_np, -1)

    # Resize the frame to a smaller size
    resized_frame = cv2.resize(img, (800, 600))

    # Preprocess the frame
    preprocessed_frame = preprocess_frame(resized_frame)

    # Perform prediction using the loaded model
    predictions = model.predict(preprocessed_frame)

    # Process the predictions as required
    # For example, you can print the predicted class or perform further analysis
    predicted_class = np.argmax(predictions)

    # Draw the predicted class on the frame
    cv2.putText(resized_frame, f"Predicted Class: {categories[predicted_class]}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 0), 2)

    # Display the frame
    cv2.imshow("Video Stream", resized_frame)

    # Exit the loop if 'q' is pressed
    if cv2.waitKey(1) == ord('q'):
        break

# Close the window
cv2.destroyAllWindows()
