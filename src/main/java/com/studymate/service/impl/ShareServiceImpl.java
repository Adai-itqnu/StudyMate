package com.studymate.service.impl;

import com.studymate.dao.ShareDao;
import com.studymate.dao.impl.ShareDaoImpl;
import com.studymate.model.Share;
import com.studymate.service.ShareService;

import java.util.List;

public class ShareServiceImpl implements ShareService {
    private final ShareDao shareDao = new ShareDaoImpl();

    @Override
    public List<Share> getSharesByPost(int postId) throws Exception {
        return shareDao.findByPostId(postId);
    }

    @Override
    public int sharePost(int userId, int postId) throws Exception {
        Share s = new Share();
        s.setUserId(userId);
        s.setPostId(postId);
        return shareDao.create(s);package com.studymate.service.impl;

import com.studymate.service.ShareService;
import com.studymate.dao.ShareDao;
import com.studymate.dao.PostDao;
import com.studymate.model.Share;
import com.studymate.model.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ShareServiceImpl implements ShareService {
    
    @Autowired
    private ShareDao shareDao;
    
    @Autowired
    private PostDao postDao;
    
    @Override
    @Transactional
    public boolean sharePost(int userId, int postId) {
        try {
            // Kiểm tra bài viết tồn tại
            Post originalPost = postDao.findById(postId);
            if (originalPost == null) {
                return false;
            }
            
            // Không cho phép chia sẻ bài viết của chính mình
            if (originalPost.getUserId() == userId) {
                return false;
            }
            
            // Kiểm tra đã chia sẻ chưa
            if (shareDao.isShared(userId, postId)) {
                return false; // Đã chia sẻ rồi
            }
            
            // Tạo bản ghi share
            Share share = new Share();
            share.setUserId(userId);
            share.setPostId(postId);
            
            boolean shareCreated = shareDao.create(share);
            
            if (shareCreated) {
                // Tạo bài viết mới với nội dung share
                Post sharedPost = new Post();
                sharedPost.setUserId(userId);
                sharedPost.setTitle("Đã chia sẻ: " + originalPost.getTitle());
                sharedPost.setBody("Bài viết được chia sẻ từ: " + originalPost.getTitle() + 
                                 "\n\nNội dung gốc: " + originalPost.getBody());
                sharedPost.setPrivacy(originalPost.getPrivacy());
                sharedPost.setStatus("PUBLISHED");
                
                return postDao.create(sharedPost);
            }
            
            return false;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public int getShareCount(int postId) {
        try {
            return shareDao.getShareCount(postId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    @Override
    public boolean isShared(int userId, int postId) {
        try {
            return shareDao.isShared(userId, postId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean deleteShare(int userId, int postId) {
        try {
            return shareDao.deleteShare(userId, postId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
    }
}