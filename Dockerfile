# Step 1: Use a super lightweight, high-performance web server image
FROM nginx:alpine

# Step 2: Copy our custom restaurant website into Nginx's public folder
COPY index.html /usr/share/nginx/html/

# Step 3: Expose port 80 so outside traffic can reach the menu
EXPOSE 80
