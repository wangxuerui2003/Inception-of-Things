To get argocd admin password:

```
argocd admin initial-password -n argocd | head -n 1
```

To get gitlab root password:

```
sudo grep '^Password:' /etc/gitlab/initial_root_password | cut -d' ' -f2-
```

---

## Manual steps

1.  Copy Gitlab password and push wil repository with to gitlab with:
    ```
    bash /vagrant/scripts/push-repo.sh
    ```

2.  Go to gitlab web UI to set project to public  
    http://gitlab.example.com/root/wil/edit#js-shared-permissions

3.  Setup argocd with:
    ```
    bash /vagrant/scripts/deploy-app.sh
    ```
