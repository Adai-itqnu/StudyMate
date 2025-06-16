package com.studymate.service.impl;

import com.studymate.dao.ShareDao;
import com.studymate.dao.impl.ShareDaoImpl;
import com.studymate.model.Share;
import com.studymate.model.Post;
import com.studymate.service.PostService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.service.ShareService;

import java.util.List;

public class ShareServiceImpl implements ShareService {
    private final ShareDao shareDao = new ShareDaoImpl();
    private final PostService postService = new PostServiceImpl();

    @Override
    public List<Share> getSharesByPost(int postId) throws Exception {
        return shareDao.findByPostId(postId);
    }

    @Override
    public int sharePost(int userId, int postId) throws Exception {
        // Tạo bản ghi chia sẻ
        Share s = new Share();
        s.setUserId(userId);
        s.setPostId(postId);
        int shareId = shareDao.create(s);

        // Tạo bài viết mới trên trang cá nhân
        Post sharedPost = new Post();
        sharedPost.setUserId(userId);
        sharedPost.setTitle("Shared a post");
        sharedPost.setBody(""); // Có thể thêm nội dung chia sẻ
        sharedPost.setPrivacy("public");
        sharedPost.setOriginalPostId(postId);
        postService.create(sharedPost, null);

        return shareId;
    }
}