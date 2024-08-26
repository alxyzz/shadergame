using UnityEngine;

public class MatchPlayerPos : MonoBehaviour
{
    public Transform target;  
     float maxRange = 3.313f; 

    private Vector3 originalPosition;

    void Start()
    {
        originalPosition = transform.position;
    }

    void Update()
    {
        Vector3 desiredPosition = new Vector3(target.position.x, transform.position.y, target.position.z);
        Vector3 offset = new Vector3(desiredPosition.x - originalPosition.x, 0f, desiredPosition.z - originalPosition.z);
        if (offset.magnitude > maxRange)
        {
            offset = offset.normalized * maxRange;
        }
        transform.position = originalPosition + offset;
    }
}
