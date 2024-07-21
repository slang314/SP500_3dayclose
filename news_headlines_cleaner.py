def scrub_file(input_file, output_file):
    with open(input_file, 'rb') as f:
        content = f.read()

    # Remove non-ASCII characters
    cleaned_content = content.decode('ascii', 'ignore').encode('ascii')

    with open(output_file, 'wb') as f:
        f.write(cleaned_content)

# Usage
input_file = 'news_headlines_2024-06-24.txt'
output_file = f'{input_file}_cleaned.csv'
scrub_file(input_file, output_file)
