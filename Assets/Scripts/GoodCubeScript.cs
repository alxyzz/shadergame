using System.Collections;
using Unity.VisualScripting.Dependencies.NCalc;
using UnityEngine;

public class GoodCubeScript : MonoBehaviour
{
    // Start is called before the first frame update
    public GameManager gm;

    Collider colliderr;
    Renderer rendererr;
    void Start()
    {
        colliderr = transform.parent.GetComponent<BoxCollider>();
        rendererr = transform.parent.GetComponent<MeshRenderer>();
        orig = rendererr.material;
    }

    // Update is called once per frame
    public void GotTouchedByTesseract()
    {
        StopAllCoroutines();
        StartCoroutine(fadeMe());
    }

    void OnTriggerEnter(Collider other)
    {


        if (other.gameObject.CompareTag("Tesseract"))
        {
            Debug.Log("tesseract touched object " + transform.name);

            GotTouchedByTesseract();
        }

    }
    
    Material orig;
    IEnumerator fadeMe()
    {

        rendererr.material = gm.RainOnGlass;
        colliderr.enabled = false;
        yield return new WaitForSecondsRealtime(3f);
        colliderr.enabled = true;
        rendererr.material = orig;
        StopAllCoroutines();
    }
    void Update()
    {

    }
}
