package com.studymate.util;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

public class CsrfFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession();
        
        // Khởi tạo CSRF token nếu chưa có
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }
        
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String sent = request.getParameter("csrfToken");
            String expect = (String) session.getAttribute("csrfToken");
            if (expect == null || !expect.equals(sent)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
        }
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}