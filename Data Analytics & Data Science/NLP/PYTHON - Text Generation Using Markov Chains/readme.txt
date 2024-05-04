This portfolio project showcases a Markov Chain Text Generator built in Python. The program utilizes natural language processing techniques to generate text that mimics the style of a given corpus. This implementation specifically leverages Markov chains of various orders to predict the likelihood of subsequent words, enhancing the contextual relevance of generated sentences.

Features
Text Preprocessing: Normalizes input text to improve the quality of tokenization.
Tokenization: Splits text into meaningful tokens using the NLTK library.
Markov Chains: Implements first, second, third, and fourth order Markov chains to capture different levels of linguistic context.
Dynamic Text Generation: Generates text based on user-selected order of Markov chain, demonstrating the flexibility and scalability of the model.

Technologies Used
Python 3.x: Primary programming language.
NLTK: Used for text preprocessing and tokenization.
NumPy: Employed for array manipulations and handling probabilistic calculations efficiently.
How to Run
Ensure Python 3.x is installed.

Install dependencies: pip install numpy nltk
Run the script: python text_generator.py (ensure you have the correct script name and path)
Follow the on-screen prompts to choose the order of the Markov chain and start generating text.

Files Included
text_generator.py: The main Python script containing the logic for text generation.
README.md: Documentation file providing an overview and setup instructions.

Future Work
Enhance the text preprocessing capabilities to include more complex patterns and noise reduction.
Implement additional fallback mechanisms to handle even more sparse scenarios.
Explore the integration of deep learning models for more advanced text generation capabilities.
