# api-integration/upload-download.md

## Objective

Standardize how the mobile application handles file upload and download.

Applies to:

* React Native
* TypeScript
* Axios / Fetch
* Clean Architecture
* Fintech / Banking apps

Main rule:

> File upload/download must be abstracted, controlled, and secure.
> Do not implement upload/download logic directly inside screens.

---

# 1. Core Principles

## 1.1 Do not handle upload/download in UI directly

Bad:

```ts
const response = await axios.post('/upload', formData);
```

Good:

```ts
await fileRepository.uploadFile(payload);
```

Rules:

* UI must not know HTTP implementation
* UI must not build FormData
* UI only passes high-level payload

---

## 1.2 Use Repository Pattern

```ts
export interface FileRepository {
  uploadFile(payload: UploadFilePayload): Promise<UploadFileResponse>;
  downloadFile(payload: DownloadFilePayload): Promise<DownloadFileResponse>;
}
```

---

# 2. Upload Handling

## 2.1 Payload Definition

```ts
export type UploadFilePayload = {
  uri: string;
  fileName: string;
  mimeType: string;
  metadata?: Record<string, unknown>;
};
```

---

## 2.2 Build FormData (Infrastructure Layer Only)

```ts
function buildFormData(payload: UploadFilePayload): FormData {
  const formData = new FormData();

  formData.append('file', {
    uri: payload.uri,
    name: payload.fileName,
    type: payload.mimeType,
  } as any);

  if (payload.metadata) {
    Object.entries(payload.metadata).forEach(([key, value]) => {
      formData.append(key, String(value));
    });
  }

  return formData;
}
```

Rules:

* Only infrastructure layer can build FormData
* Do not expose FormData to UI
* Always validate file before upload

---

## 2.3 Upload API Call

```ts
await axios.post('/upload', formData, {
  headers: {
    'Content-Type': 'multipart/form-data',
  },
});
```

---

## 2.4 Upload Progress

```ts
onUploadProgress: (progressEvent) => {
  const percent = Math.round(
    (progressEvent.loaded * 100) / progressEvent.total
  );
}
```

Rules:

* Progress must be optional
* Do not tightly couple progress logic with UI

---

# 3. Download Handling

## 3.1 Download File

```ts
const response = await axios.get('/file', {
  responseType: 'blob',
});
```

---

## 3.2 Save File (React Native)

Use libraries:

* react-native-fs
* expo-file-system

Example:

```ts
await RNFS.writeFile(path, data, 'base64');
```

---

## 3.3 Open File

```ts
import FileViewer from 'react-native-file-viewer';

await FileViewer.open(path);
```

---

# 4. Error Handling

Upload/Download must reuse:

```ts
normalizeApiError(error);
```

---

# 5. Security Rules (CRITICAL)

## 5.1 Validate file before upload

* file size limit
* mime type whitelist
* file extension check

---

## 5.2 Do not trust client file name

Always sanitize on backend.

---

## 5.3 Sensitive file handling

Do not allow:

* private key files
* system files
* executable files

---

# 6. Fintech Rules

## 6.1 Common use cases

* KYC document upload
* Avatar upload
* Transaction receipt download
* Statement download

---

## 6.2 Do not expose sensitive file URL

Bad:

```txt
https://s3/.../user123/id-card.png
```

Good:

```txt
GET /files/{id} -> authorized download
```

---

## 6.3 Use signed URL (if needed)

* short TTL
* one-time access

---

# 7. Logging Rules

Do not log:

* file content
* file path (sensitive)
* personal documents

Allowed:

* file size
* mime type
* upload success/failure

---

# 8. Performance Rules

* Use chunk upload for large files
* Limit concurrent uploads
* Cancel upload when leaving screen

---

# 9. Checklist

* [ ] Upload logic is in repository
* [ ] FormData is not exposed to UI
* [ ] File validation is implemented
* [ ] Error is normalized
* [ ] Sensitive data is not logged
* [ ] Download uses secure endpoint

---

# 10. Final Rule

> File upload/download must be secure, controlled, and abstracted.
> Never let UI directly manage low-level file or network logic.
