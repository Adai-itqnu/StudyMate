package com.studymate.service.impl;

import com.studymate.dao.*;
import com.studymate.dao.impl.*;
import com.studymate.model.Attachment;
import com.studymate.model.Comment;
import com.studymate.model.Post;
import com.studymate.service.PostService;

import java.util.List;

public class PostServiceImpl implements PostService {

    private final PostDao postDao             = new PostDaoImpl();
    private final AttachmentDao attachmentDao = new AttachmentDaoImpl();
    private final LikeDao likeDao             = new LikeDaoImpl();
    private final CommentDao commentDao       = new CommentDaoImpl();

    @Override
    public int create(Post post, String fileUrl) throws Exception {
        int postId = postDao.create(post);
        if (fileUrl != null) {
            Attachment a = new Attachment();
            a.setPostId(postId);
            a.setFileUrl(fileUrl);
            a.setFileType("IMAGE");
            attachmentDao.create(a);
        }
        return postId;
    }
    
    @Override
    public Post findById(int postId) {
        return postDao.findById(postId);
    }
    
    @Override
    public List<Post> findAll() throws Exception {
        List<Post> posts = postDao.findAll();
        for (Post p : posts) {
            p.setAttachments(attachmentDao.findByPostId(p.getPostId()));
        }
        return posts;
    }

    @Override
    public List<Post> findAllWithDetails() throws Exception {
        List<Post> posts = postDao.findAll();
        for (Post p : posts) {
            int pid = p.getPostId();
            p.setAttachments(attachmentDao.findByPostId(pid));
            p.setLikeCount(likeDao.countByPostId(pid));
            List<Comment> cmts = commentDao.findByPostId(pid);
            p.setComments(cmts);
            p.setCommentCount(cmts.size());
        }
        return posts;
    }

    @Override
    public void delete(int postId) throws Exception {
        boolean success = postDao.delete(postId);
        if (!success) {
            throw new Exception("Failed to delete post with ID: " + postId);
        }
    }
    
    
}
	