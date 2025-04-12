// Sample data - replace with actual API calls
document.addEventListener('DOMContentLoaded', function() {
    // Fetch user data from localStorage or session
    const user = JSON.parse(localStorage.getItem('user')) || { name: 'Farmer' };
    document.querySelector('.user-profile span').textContent = `Welcome, ${user.name}!`;

    // Recent detections table
    const detections = [
        { date: '2025-04-10', pest: 'Beetle', crop: 'Tomato', severity: 'high' },
        { date: '2025-04-08', pest: 'Caterpillar', crop: 'Cabbage', severity: 'medium' },
        { date: '2025-04-05', pest: 'Aphid', crop: 'Pepper', severity: 'low' },
        { date: '2025-04-03', pest: 'Whitefly', crop: 'Tomato', severity: 'medium' }
    ];

    const tableBody = document.getElementById('detectionTable');
    detections.forEach(detection => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${detection.date}</td>
            <td>${detection.pest}</td>
            <td>${detection.crop}</td>
            <td class="severity-${detection.severity}">${detection.severity.charAt(0).toUpperCase() + detection.severity.slice(1)}</td>
            <td>
                <a href="#" class="action-btn">View</a>
                <a href="#" class="action-btn">Treat</a>
            </td>
        `;
        tableBody.appendChild(row);
    });

    // Update stats cards
    document.getElementById('recentDetections').textContent = detections.length;
    document.getElementById('protectedCrops').textContent = '12';
    document.getElementById('alerts').textContent = '3';

    // In a real app, you would fetch this data from your PHP API:
    /*
    fetch('php/get_detections.php')
        .then(response => response.json())
        .then(data => {
            // Process and display data
        });
    */
});