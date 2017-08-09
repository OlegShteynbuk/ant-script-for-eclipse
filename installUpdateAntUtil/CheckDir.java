/*
 *
 */
package installUpdateAntUtil;

import java.io.File;
import java.io.FilenameFilter;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.MatchingTask;
import org.apache.tools.ant.taskdefs.condition.Condition;

/**
 * This Ant task sets a property if only one file that could be used as an
 * Eclipse build is available at runtime. Right now the condition is that
 * file should be ".zip". If the file is present the property value is set
 * to true by default; otherwise, the property is not set.
 * This task may also be used as a condition by the condition task.
 * Similar to Available task.
 * MatchingTask for possible future extensions.

 *
 * @author Oleg Shteynbuk
 *         <a href="mailto:oleg_shteynbuk@yahoo.com">oleg_shteynbuk@yahoo.com</a>
 */
public class CheckDir extends MatchingTask implements Condition {

	private String property;
	private String value = "true";
	static String ext = ".zip";
	private String dir;
	private int filesInDir = 1;

	public void execute() throws BuildException {
		if (property == null) {
			throw new BuildException(
				"property attribute is required",
				getLocation());
		}

		if (eval()) {
			String oldvalue = getProject().getProperty(property);
			if (null != oldvalue && !oldvalue.equals(value)) {
				// change to log
				System.out.println(
					"Build file should not reuse the same property"
						+ " name for different values.");
			}
			getProject().setProperty(property, value);
		} else {
			// change to log
			System.out.println(
				" should be only "
					+ this.filesInDir
					+ " file with pattern \""
					+ ext
					+ "\" in directory \""
					+ dir
					+ "\"");
		}

	}
	/**
	 * Sets the dir.
	 * @param dir The dir to set
	 */
	public void setDir(String dir) {
		this.dir = dir;
	}
	/**
	 * Evaluate the availability of a resource.
	 *
	 * @return boolean if the resource is available.
	 * @exception BuildException if the condition is not configured correctly
	 * @see org.apache.tools.ant.taskdefs.condition.Condition#eval()
	 */
	public boolean eval() throws BuildException {
		String[] dirList = null;
		dirList = new java.io.File(dir).list(new FilenameFilter() {
			public boolean accept(File dir, String s) {
				if (s.endsWith(CheckDir.ext)) {
					return true;
				}
				return false;

			}
		});

		if ( (dirList == null) || (dirList.length != this.filesInDir) ) {
			return false;
		}
		return true;
	}

	/**
	 * Set the name of the property which will be set if the resource
	 * is available.
	 *
	 * @param property The property to set
	 */
	public void setProperty(String property) {
		this.property = property;
	}
	/**
	 * Sets the value.
	 * @param value The value to set
	 */
	public void setValue(String value) {
		this.value = value;
	}

}