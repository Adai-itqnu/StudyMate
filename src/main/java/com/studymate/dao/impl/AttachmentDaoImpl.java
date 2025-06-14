package com.studymate.dao.impl;

import com.studymate.dao.AttachmentDao;
import com.studymate.model.Attachment;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttachmentDaoImpl implements AttachmentDao {
    private static final String INSERT_SQL = 
        "INSERT INTO attachments (post_id, file_url, file_type) VALUES (?, ?, ?)";
    private static final String SELECT_BY_POST_ID = 
        "SELECT * FROM attachments WHERE post_id = ?";
    private static final String DELETE_BY_ID_SQL =
    	      "DELETE FROM post_attachments WHERE attachment_id = ?";

    @Override
    public int create(Attachment att) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, att.getPostId());
            ps.setString(2, att.getFileUrl());
            ps.setString(3, att.getFileType());
            
            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating attachment failed, no rows affected.");
            }
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Creating attachment failed, no ID obtained.");
                }
            }
        }
    }

    @Override
    public List<Attachment> findByPostId(int postId) throws Exception {
        List<Attachment> attachments = new ArrayList<>();
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_POST_ID)) {
            
            ps.setInt(1, postId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attachment att = new Attachment();
                    att.setAttachmentId(rs.getInt("attachment_id"));
                    att.setPostId(rs.getInt("post_id"));
                    att.setFileUrl(rs.getString("file_url"));
                    att.setFileType(rs.getString("file_type"));
                  //  att.setCreatedAt(rs.getTimestamp("created_at"));
                    attachments.add(att);
                }
            }
        }
        
        return attachments;
    }
    @Override
    public boolean deleteById(int attachmentId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_BY_ID_SQL)) {
            ps.setInt(1, attachmentId);
            return ps.executeUpdate() > 0;
        }
    }
}