FROM infracloudio/csvserver:latest
WORKDIR /app
COPY gencsv.sh /app/gencsv.sh
RUN chmod +x /app/gencsv.sh
CMD ["./gencsv.sh", "2", "8"]
