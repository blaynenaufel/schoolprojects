import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URI;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.util.Progressable;

/**
 * Christopher Blayne Naufel
 * CS 4300 Cloud Computing
 * Dr. Shi
 * 9/29/14
 */
public class CS4300Assignment1 {

	public static void main(String[] args) throws Exception {
		String pathName = "hdfs://npvm11.np.wc1.yellowpages.com:9000/user/john/abc.txt";
		Path path = new Path(pathName);
		FileSystem fs = FileSystem.get(new Configuration());
		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fs.open(path)));
		String currentline = bufferedReader.readLine();
		do {
			String[] lineSplit = currentline.split(" ");
			String longestWordInLine= "";
			for(int i = 0; i < lineSplit.length; i++)
			{
				if (lineSplit[i].length() > longestWordInLine.length())
				{
					longestWordInLine = lineSplit[i];
				}
				System.out.println(longestWordInLine);
			}
		} while (currentline != null);
	}
}
