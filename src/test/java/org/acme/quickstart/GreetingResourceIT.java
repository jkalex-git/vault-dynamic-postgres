package org.acme.quickstart;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Random;

public class GreetingResourceIT {

    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        Random random = new Random();

        String[] urls = {
                "http://localhost:8080/items",
                "http://localhost:8080/specialItems",
        };

        while (true) {
            // Pick a random URL
            String url = urls[random.nextInt(urls.length)];

            try {
                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .timeout(Duration.ofSeconds(10))
                        .GET()
                        .build();

                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
                if(response.statusCode() > 210) {
                    System.out.println("URL: " + url + " | Status: " + response.statusCode());
                    break;
                } else {
                    System.out.println("URL: " + url + " | Status: " + response.statusCode());
                }

                // Optional: print response body
                // System.out.println(response.body());
            } catch (Exception e) {
                System.err.println("Request failed: " + e.getMessage());
            }

            // Sleep random 1–5 seconds
            int sleepSeconds = 1 + random.nextInt(5); // 1 to 5
            Thread.sleep(sleepSeconds * 1000L);
        }
    }
}
