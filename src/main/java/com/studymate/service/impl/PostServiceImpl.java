package com.studymate.service.impl;

import com.studymate.dao.AttachmentDao;
import com.studymate.dao.PostDao;
import com.studymate.dao.impl.AttachmentDaoImpl;
import com.studymate.dao.impl.PostDaoImpl;
import com.studymate.model.Attachment;
import com.studymate.model.Post;
import com.studymate.service.PostService;

import java.util.List;

public class PostServiceImpl implements PostService {
    private final PostDao postDao = new PostDaoImpl();
    private final AttachmentDao attachmentDao = new AttachmentDaoImpl();

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
    public List<Post> findAll() throws Exception {
        List<Post> posts = postDao.findAll();
        for (Post p : posts) {
            p.setAttachments(attachmentDao.findByPostId(p.getPostId()));
        }
        return posts;
    }
}
