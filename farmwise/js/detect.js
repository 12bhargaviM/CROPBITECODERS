document.getElementById('uploadBtn').addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (file) {
        const preview = document.getElementById('imagePreview');
        const reader = new FileReader();
        
        reader.onload = function(event) {
            preview.src = event.target.result;
            preview.style.display = 'block';
            
            // Show loader
            document.getElementById('loader').style.display = 'block';
            document.getElementById('results').style.display = 'none';
            
            // Prepare form data
            const formData = new FormData();
            formData.append('image', file);
            
            // Send to Flask backend
            fetch('/predict', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(text || 'Server error');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                
                // Hide loader and show results
                document.getElementById('loader').style.display = 'none';
                document.getElementById('pestName').textContent = data.pest;
                document.getElementById('confidence').textContent = (data.confidence * 100).toFixed(2);
                document.getElementById('prevention').textContent = data.prevention;
                document.getElementById('treatment').textContent = data.treatment;
                document.getElementById('results').style.display = 'block';
            })
            .catch(error => {
                document.getElementById('loader').style.display = 'none';
                console.error('Error:', error);
                alert('Error: ' + error.message);
            });
        };
        
        reader.readAsDataURL(file);
    }
});