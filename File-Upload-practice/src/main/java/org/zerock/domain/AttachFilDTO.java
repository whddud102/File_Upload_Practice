package org.zerock.domain;

import lombok.Data;

/**
 * 첨부파일의 정보를 전달할 객체
 * @author whddud
 *
 */
@Data
public class AttachFilDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean isImage;
}
