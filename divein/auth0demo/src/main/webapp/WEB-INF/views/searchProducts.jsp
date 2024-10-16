<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.stream.Collectors" %>
<%
    // Example product class (replace this with actual product object logic from DB)
    class Product {
        String name;
        String description;
        
        public Product(String name, String description) {
            this.name = name;
            this.description = description;
        }

        public String getName() {
            return name;
        }

        public String getDescription() {
            return description;
        }
    }

    // Sample list of products (in real cases, fetch from the database)
    List<Product> allProducts = new ArrayList<>();
    allProducts.add(new Product("Laptop", "High performance laptop"));
    allProducts.add(new Product("Phone", "Smartphone with good battery life"));
    allProducts.add(new Product("Tablet", "Portable tablet for reading and browsing"));

    // Get the search query from the request parameter
    String searchQuery = request.getParameter("searchQuery");
    List<Product> filteredProducts = new ArrayList<>();

    if (searchQuery != null && !searchQuery.isEmpty()) {
        // Filter the products based on the search query (case insensitive)
        filteredProducts = allProducts.stream()
            .filter(product -> product.getName().toLowerCase().contains(searchQuery.toLowerCase()) ||
                               product.getDescription().toLowerCase().contains(searchQuery.toLowerCase()))
            .collect(Collectors.toList());
    } else {
        // If no search query is provided, show all products
        filteredProducts = allProducts;
    }
%>

<h2>Product List</h2>
<ul>
<% for (Product product : filteredProducts) { %>
    <li><strong><%= product.getName() %></strong>: <%= product.getDescription() %></li>
<% } %>
</ul>
