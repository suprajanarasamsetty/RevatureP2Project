package com.example.demo.controller;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.oidc.OidcIdToken;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.CartResponse;
import com.example.demo.dto.FavouriteResponse;
import com.example.demo.dto.ProductResponse;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FavouriteService;
import com.example.demo.service.ProductService;

import jakarta.servlet.http.HttpSession;
import reactor.core.publisher.Mono;


@CrossOrigin(origins = "*")
@Controller
@RequestMapping("/jsp")
public class EcommerceController {
	private final ProductService productService;
	private CategoryService categoryService;
	private final FavouriteService favouriteService;
	
	private CartService cartService;
	@Autowired
	public EcommerceController(ProductService productService, CategoryService categoryService,CartService cartService,FavouriteService favouriteService) {
		this.productService = productService;
		this.categoryService=categoryService;
		this.cartService=cartService;
		this.favouriteService=favouriteService;
	}
    @GetMapping("/home")
    public String home() {
    	System.out.println("home");
            return "home";  
    }
    
   
    @GetMapping("/updateProduct")
    public String updateProduct() {
            return "updateProduct";  
    }
    @GetMapping("/registerAsSeller")
    public String registerAsSeller() {
            return "registerAsSeller";  
    }
    @GetMapping("/ProductManager")
    public String ProductManager(Model model,@AuthenticationPrincipal OidcUser oidcUser, HttpSession session) {
    	if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
    	String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching user ID for buyer dashboard: " + userId);

        // Store userId in the session if not already present
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", userId);
        }

        // Optionally add user ID to the model for use in the view
        model.addAttribute("userId", userId);

            return "ProductManager";  
    }
//    @GetMapping("/cart")
//    public String Cart(Model model, HttpSession session, @AuthenticationPrincipal OidcUser oidcUser) {
//        if (oidcUser == null) {
//            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
//        }
//
//        // Get the user ID from the OIDC user token
//        String userId = oidcUser.getIdToken().getSubject();
//
//        // Assuming you have a CartService or CartClient to retrieve cart items by user ID
//        List<CartResponse> cartItems = cartService.getCartsByUserId(userId);
//
//        // Print the list of cart items for debugging
//        System.out.println("Cart Items for user ID: " + userId + " -> " + cartItems);
//
//        // Add the list of cart items to the model
//        model.addAttribute("cartItems", cartItems);
//
//        return "cart";  // Return the updated cart.jsp page with the cart items
//    }

    @GetMapping("/cart")
    public String Cart(Model model,@AuthenticationPrincipal OidcUser oidcUser, HttpSession session) {
    	if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
    	String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching user ID for buyer dashboard: " + userId);

        // Store userId in the session if not already present
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", userId);
        }

        // Optionally add user ID to the model for use in the view
//        model.addAttribute("userId", userId);
//    	List<CartResponse> cart=cartService.getCartsByUserId(userId);
//    	model.addAttribute("cart",cart);
    	return "cart";
    }
    @GetMapping("/favorite")
    public String Favourite(Model model,@AuthenticationPrincipal OidcUser oidcUser,HttpSession session) {
    	if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
    	String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching user ID for buyer dashboard: " + userId);

        // Store userId in the session if not already present
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", userId);
        }
//    	Mono<List<FavouriteResponse>> fav=favouriteService.getFavouritesByUserId(session.getAttribute("userId").toString());
//    	model.addAttribute("fav",fav);
    	return "favorite";
    }	
    
   
    @GetMapping("/UserProduct")
    public String viewProduct() {
            return "UserProduct";  
    }
    @GetMapping("/buyerdashboard")
    public String buyerdashboard(@RequestParam(value = "category", required = false) String category,@AuthenticationPrincipal OidcUser oidcUser, Model model, HttpSession session) {
    	if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
    	String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching user ID for buyer dashboard: " + userId);

        // Store userId in the session if not already present
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", userId);
        }

        // Optionally add user ID to the model for use in the view
        model.addAttribute("userId", userId);

    	List<ProductResponse> products;

        if (category != null && !category.isEmpty()) {
            // Fetch products by category if a category is specified
            products = productService.getProductsByCategory(category);

        } else {
            // Otherwise, fetch all products
            products = productService.getAllProducts();
        }
        System.out.println("category" + category);
        session.setAttribute("products", products);



        // Add products and categories to the model
        model.addAttribute("products", products);
        model.addAttribute("categories", categoryService.getAllCategories()); // Assuming this service fetches all categories

        return "buyerdashboard"; // Return the name of the JSP page to render
    }


    @GetMapping("/sellerdashboard")
    public String sellerdashboard(Model model) {
    	List<ProductResponse> products = productService.getAllProducts();
    	model.addAttribute("products", products);
            return "sellerdashboard";  
    }
    @GetMapping("/BuyNow")
    public String Buynow6() {
            return "BuyNow";  
    }
    
    @GetMapping("/inventory")
    public String inventory() {
            return "inventory";  
    }
    
    @GetMapping("/successpage")
    public String successpage() {
            return "successpage";  
    }
    @GetMapping("/home2")
    public String home2() {
            return "home2";  
    }
    @GetMapping("/createProduct")
    	 public String createProduct(Model model, @AuthenticationPrincipal OidcUser oidcUser,HttpSession session) {
    	if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
    	String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching user ID for buyer dashboard: " + userId);

        // Store userId in the session if not already present
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", userId);
        }
            return "createProduct";  
    }
    
    @GetMapping("/viewOrders")
    public String viewOrders(Model model, @AuthenticationPrincipal OidcUser oidcUser, HttpSession session) {
        if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
        
        String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching orders for user ID: " + userId);

        // Store userId in the session
        session.setAttribute("userId", userId);

        // Retrieve user ID from the OIDC token
        System.out.println("Fetching orders for user ID: " + userId);

        // Fetch orders for the user

        return "viewOrders";  
    }
    
    @GetMapping("/ProdByuser")
	 public String ProdByuser(Model model, @AuthenticationPrincipal OidcUser oidcUser) {
	        if (oidcUser == null) {
	            // User is not authenticated, redirect to login or return an error page
	            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
	        }

	        model.addAttribute("profile", oidcUser.getClaims());
	        

	        OidcIdToken idToken = oidcUser.getIdToken();
	     
	        System.out.println("ID Token Subject: " + idToken.getSubject());

	         // Return the profile view
       return "ProdByuser";  
}

    @GetMapping("/categories")
    public String categories() {
        return "categories"; 
    }

    

    @GetMapping("/orders")
    public String orders(@AuthenticationPrincipal OidcUser oidcUser, HttpSession session) {
    	if (oidcUser == null) {
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }
    	String userId = oidcUser.getIdToken().getSubject();
        System.out.println("Fetching user ID for buyer dashboard: " + userId);

        // Store userId in the session if not already present
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", userId);
        }
        return "orders";  
    }

    @GetMapping("/login")
    public String login() {
        return "login";  
    }
    @GetMapping("/editProduct")
    public String update(@RequestParam Long id,Model model)
    {
    	model.addAttribute("productId",id);
    	
        return "updateProduct";  
    }

 
    @GetMapping("/profile")
    public String getProfile(Model model, @AuthenticationPrincipal OidcUser oidcUser) {
        if (oidcUser == null) {
            // User is not authenticated, redirect to login or return an error page
            return "redirect:/jsp/login";  // Redirect to login page if not authenticated
        }

        model.addAttribute("profile", oidcUser.getClaims());
        
        if (oidcUser.getUserInfo() != null) {
            OidcUserInfo userInfo = oidcUser.getUserInfo();
            System.out.println("User Info Claims: " + userInfo.getClaims());
            System.out.println("User Email: " + userInfo.getEmail());
            System.out.println("User Name: " + userInfo.getFullName());
            System.out.println("User Gender: " + userInfo.getGender());
        } else {
            System.out.println("No UserInfo available");
        }

        OidcIdToken idToken = oidcUser.getIdToken();
        System.out.println("ID Token Claims: " + idToken.getClaims());
        System.out.println("ID Token Subject: " + idToken.getSubject());
        System.out.println("ID Token Issuer: " + idToken.getIssuer());
        System.out.println(idToken.getTokenValue());

        return "profile";  // Return the profile view
    }


}

